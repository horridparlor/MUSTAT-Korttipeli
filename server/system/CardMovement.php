<?php

class  CardMovement
{
    function move_card(
        ?int $instance_id,
        ?String $from_name,
        ?String $to_name,
        ?Database $database,
        ?mysqli $connection,
        ?int $switch_owner_to = -1
    ) {
        $card = $database->extrapolate_card($instance_id, $connection);
        $game_id = $card["game_id"];
        $player_id = $card["player_id"];
        $old_zone = $database->get_zone_id($from_name, $connection);
        $new_zone = $database->get_zone_id($to_name, $connection);
        $identify_playmat =
            " WHERE game_id = " . $game_id .
            " AND player_id = " . $player_id . " ";
        $identify_card =
            $identify_playmat .
            "AND instance_id = " . $instance_id;
        $status = "[0]";
        $change_owner = [];
        if ($switch_owner_to >= 0) {
            $card["player_id"] = $switch_owner_to;
            array_push($change_owner, $this->change_owner_query($switch_owner_to, $identify_card));
        }
        if ($database->game_not_ended($game_id, $connection) or $this->allowed_to_move(
            $card,
            $identify_card,
            $identify_playmat,
            $old_zone,
            $new_zone,
            $database,
            $connection
        )) {
            $move_card = $this->zone_change_query($identify_card, $new_zone);
            $update_slots = $this->update_cards_slots(
                $card,
                $instance_id,
                $identify_card,
                $identify_playmat,
                $old_zone,
                $new_zone,
                $database,
                $connection
            );
            foreach (array_merge([$move_card], $change_owner, $update_slots) as $query) {
                $connection->query($query);
            }
            $this->move_functions($old_zone, $new_zone, $card, $identify_playmat, $database, $connection);
            $status = "[1]";
        }
        return $status;
    }

    function allowed_to_move(
        ?array $card,
        ?String $identify_card,
        ?String $identify_playmat,
        ?int $zone_from,
        ?int $zone_to,
        ?Database $database,
        ?mysqli $connection
    ) {
        $current_zone_query =
            "FROM card_instance
        JOIN zone
        ON zone_id = zone.id" .
            $identify_card;
        $current_zone = $database->exact_query("id", $current_zone_query, $connection);
        if (
            $zone_from != $current_zone or
            $database->zone_filled($zone_to, $card, $connection) or
            $this->not_enough_mana($zone_from, $zone_to, $card, $identify_playmat, $database, $connection)
        ) {
            return false;
        }
        return true;
    }

    function not_enough_mana(
        ?int $zone_from,
        ?int $zone_to,
        ?array $card,
        ?String $identify_playmat,
        ?Database $database,
        ?mysqli $connection
    ) {
        if ($zone_from != 1 or $zone_to != 2) {
            return false;
        }
        $mana_left_query =
            "FROM playmat" .
            $identify_playmat;
        $mana_left = $database->exact_query("mana", $mana_left_query, $connection);
        $mana_cost = $database->pull_cost($card);
        if ($mana_cost > $mana_left) {
            return true;
        }
        $this->play_card($card, $identify_playmat, $mana_cost, $database, $connection);
        return false;
    }

    function play_card(?array $card, ?String $identify_playmat, ?int $mana_cost, ?Database $database, ?mysqli $connection)
    {
        $database->trigger_card_effects($card["game_id"], -1, "play", $connection, $card["instance_id"]);
        $this->update_mana_left($identify_playmat, $mana_cost, "-", $connection);
    }

    function update_mana_left(?String $identify_playmat, ?int $mana_cost, ?String $operator, ?mysqli $connection)
    {
        $query =
            "UPDATE playmat
        SET mana = mana " . $operator . " " . $mana_cost .
            $identify_playmat;
        $connection->query($query);
    }

    function refund_mana(?int $zone_from, ?int $zone_to, ?array $card, ?String $identify_playmat, ?Database $database, ?mysqli $connection)
    {
        if ($zone_from != 2 or $zone_to != 1) {
            return;
        }
        $mana_cost = $database->pull_cost($card);
        $this->update_mana_left($identify_playmat, $mana_cost, "+", $connection);
    }

    function zone_change_query(?String $identify_card, ?String $new_zone)
    {
        return "UPDATE card_instance
    SET zone_id = " . $new_zone .
            $identify_card;
    }

    function update_cards_slots(
        ?array $card,
        ?int $card_id,
        ?string $identify_card,
        ?string $identify_playmat,
        ?string $old_zone,
        ?string $new_zone,
        ?Database $database,
        ?mysqli $connection
    ) {
        $select_card =
            "FROM card_instance" . $identify_card;
        $old_slot = $database->exact_query("card_slot", $select_card, $connection);
        $highest_slot = $database->highest_slot($card, $new_zone, $connection, $card_id);
        if ($highest_slot == -1) {
            $highest_slot = 0;
        }
        $update_card =
            "UPDATE card_instance
        SET card_slot = " . $highest_slot . " + 1" .
            $identify_card;
        $update_others = $this->update_others_query($identify_playmat, $old_zone, $old_slot);
        $queries = [$update_card, $update_others];
        return $queries;
    }

    function update_others_query(?String $identify_playmat, ?String $old_zone, ?int $old_slot)
    {
        return "UPDATE card_instance
    SET card_slot = card_slot - 1" .
            $identify_playmat .
            "AND zone_id = " . $old_zone .
            " AND card_slot > " . $old_slot;
    }

    function draw_card(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection, ?int $switch_owner_to = -1)
    {
        $query =
            "FROM card_instance
            LEFT JOIN " . $database->card_effect_table() . " on base_id = owner_id
            WHERE game_id = " . $game_id
            . " AND player_id = " . $player_id
            . " AND zone_id = 0
            AND (trigger_condition IS NULL OR trigger_condition != \"cannot_be_drawn\")
            ORDER by card_slot";
        $top_card = $database->exact_query("instance_id", $query, $connection);
        if (!$database->test_exact_success($top_card)) {
            return;
        }
        $this->move_card($top_card, "deck", "hand", $database, $connection, $switch_owner_to);
        $database->trigger_card_effects($game_id, -1, "draw", $connection, $top_card);
    }

    function change_owner_query(?int $new_owner, ?string $identify_card)
    {
        return
            "UPDATE card_instance
            SET player_id = " . $new_owner
            . $identify_card;
    }

    function move_functions(?int $old_zone, ?int $new_zone, ?array $card, ?string $identify_playmat, ?Database $database, ?mysqli $connection)
    {
        $this->refund_mana($old_zone, $new_zone, $card, $identify_playmat, $database, $connection);
        if ($new_zone == 1) {
            $this->shuffle_deck($card["game_id"], $card["player_id"], $database, $connection);
        }
    }

    function shuffle_deck(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection)
    {
        $extra_condition =
            "AND player_id = " . $player_id .
            " AND zone_id = 0";
        $cards = $database->get_cards($game_id, $connection, $extra_condition);
        $card_slots = [];
        foreach ($cards as $card) {
            array_push($card_slots, $card["card_slot"]);
        }
        shuffle($card_slots);
        for ($i = 0; $i < sizeof($card_slots); $i++) {
            $query =
                "UPDATE card_instance
                SET card_slot = " . $card_slots[$i]
                . " WHERE instance_id = " . $cards[$i]["instance_id"];
            $connection->query($query);
        }
    }
}
