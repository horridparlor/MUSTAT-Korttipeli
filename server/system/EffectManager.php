<?php

class  EffectManager
{
    function trigger_effect(?array $effect, ?Database $database, ?mysqli $connection)
    {
        $card = $database->extrapolate_card($effect["instance_id"], $connection);
        $card_movement = new CardMovement();
        $value = $effect["value"];
        switch ($effect["effect"]) {
            case "default_power":
                $this->default_power($card, $effect, $database, $connection);
            case "draw":
                $this->draw($card, $effect, $card_movement, $database, $connection);
                break;
            case "gain_cost":
                $this->gain_cost($value, $card, $effect, $database, $connection);
                break;
            case "gain_power":
                if ($value == 0) {
                    $value = $effect["power"];
                }
                $this->gain_power($value, $card, $effect, $database, $connection);
                break;
            case "multiply_own_power":
                $this->multiply_own_power($card, $effect, $database, $connection);
                break;
            case "multiply_power":
                $this->multiply_power($card, $effect, $database, $connection);
                break;
            case "spawn_card":
                $this->spawn_card($card, $effect, $card_movement, $database, $connection);
                break;
            case "split_card":
                $this->split_card($card, $effect, $card_movement, $database, $connection);
                break;
            case "stat_flip":
                $this->stat_flip($card, $effect, $database, $connection);
                break;
            case "steal_card":
                $this->steal_card($card, $effect, $card_movement, $database, $connection);
                break;
        }
    }

    function default_power(?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        $cards = $this->get_cards($card, $effect, $database, $connection);
        foreach ($cards as $card) {
            $this->default_stat("power", $card, $connection);
        }
    }

    function default_stat(?string $stat, ?array $card, ?mysqli $connection)
    {
        $query =
            "UPDATE card_instance
            SET " . $stat . "_change = 0
            WHERE instance_id = " . $card["instance_id"];
        $connection->query($query);
    }

    function draw(?array $card, ?array $effect, ?CardMovement $card_movement, ?Database $database, ?mysqli $connection)
    {
        $switch_owner_to = -1;
        if ($effect["condition_1"] == "from_opponent") {
            $switch_owner_to = $card["player_id"];
            $card["player_id"] = $database->get_opponent_card($card, $connection);
        }
        for ($i = 0; $i < $effect["value"]; $i++) {
            $card_movement->draw_card($card["game_id"], $card["player_id"], $database, $connection, $switch_owner_to);
        }
    }

    function gain_cost(?int $cost_change, ?array $card, ?array $effect, ?database $database, ?mysqli $connection)
    {
        if ($this->is_mass_effect($effect)) {
            $this->mass_gain_cost($cost_change, $card, $effect, $database, $connection);
            return;
        }
        $this->gain_stat($cost_change, "cost", $effect, $database, $connection);
    }

    function is_mass_effect(?array $effect)
    {
        return str_contains($effect["condition_1"], "where");
    }

    function mass_gain_cost(?int $cost_change, ?array $card, ?array $effect, ?database $database, ?mysqli $connection)
    {
        $cards = $this->get_cards($card, $effect, $database, $connection);
        $effect = $this->sterilize_conditions($effect);
        foreach ($cards as $card) {
            $effect = $this->lock_effect_to_card($card, $effect);
            $this->gain_cost($cost_change, $card, $effect, $database, $connection);
        }
    }

    function sterilize_conditions(?array $effect)
    {
        if ($this->is_mass_effect($effect)) {
            $effect["condition_1"] = "";
        }
        return $effect;
    }

    function lock_effect_to_card(?array $card, ?array $effect)
    {
        $effect["instance_id"] = $card["instance_id"];
        return $effect;
    }

    function get_cards(?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        $query =
            "JOIN " . $database->card_table()
            . " ON base_id = " . $database->card_table() . ".id
            LEFT JOIN " . $database->card_effect_table()
            . " ON base_id = owner_id
            WHERE game_id = " . $card["game_id"] . $this->parse_conditions($card, $effect);
        return $database->card_query($query, $connection);
    }

    function parse_conditions(?array $card, ?array $effect)
    {
        $conditions =
            " AND instance_id != " . $effect["instance_id"] .
            " AND zone_id != 3";
        $group_by_clause =
            " GROUP BY instance_id ";
        foreach ([
            [$effect["condition_1"], $effect["value_1"]],
            [$effect["condition_2"], $effect["value_2"]]
        ] as $condition) {
            $value = $condition[1];
            switch ($condition[0]) {
                case "where_cost_is":
                    $conditions .= " AND cost + cost_change = " . $value;
                    break;
                case "where_location_is":
                    if ($value == 4) {
                        continue;
                    } else {
                        $conditions .= " AND zone_id = " . $value;
                    }
                    break;
                case "where_owner_is":
                    $owner_operation = "=";
                    if ($value != 1) {
                        $owner_operation = "!=";
                    }
                    $conditions .= " AND player_id " . $owner_operation . " " . $card["player_id"];
                    break;
            }
        }
        switch ($effect["restriction"]) {
            case "end_of_game":
                $conditions .= " AND trigger_condition = \"end_of_game\"";
                break;
            case "vanilla":
                $group_by_clause .=
                    "HAVING COUNT(owner_id) = 0";
                break;
        }
        return $conditions . $group_by_clause;
    }

    function gain_power(?int $power_change, ?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        if ($this->is_mass_effect($effect)) {
            $this->mass_gain_power($power_change, $card, $effect, $database, $connection);
            return;
        } else if ($effect["restriction"] != "no_chain" and $power_change > 0) {
            $database->trigger_card_effects($card["game_id"], $card["player_id"], "whenever_power", $connection);
        }
        $this->gain_stat($power_change, "power", $effect, $database, $connection);
    }

    function mass_gain_power(?int $power_change, ?array $card, ?array $effect, ?database $database, ?mysqli $connection)
    {
        $cards = $this->get_cards($card, $effect, $database, $connection);
        $effect = $this->sterilize_conditions($effect);
        foreach ($cards as $card) {
            $effect = $this->lock_effect_to_card($card, $effect);
            $this->gain_power($power_change, $card, $effect, $database, $connection);
        }
    }

    function gain_stat(?int $amount, ?string $stat, ?array $effect, ?database $database, ?mysqli $connection)
    {
        $card_id = $effect["instance_id"];
        $new_stat_gain = $this->floor_stat_gain($amount, $stat, $card_id, $database, $connection);
        $query =
            "UPDATE card_instance
            SET " . $stat . "_change = " . $new_stat_gain
            . " WHERE instance_id = " . $card_id;
        $connection->query($query);
    }

    function floor_stat_gain(?int $new_gain, ?string $stat, ?int $card_id, ?database $database, ?mysqli $connection)
    {
        $card = $database->extrapolate_card($card_id, $connection);
        $base_stat = $card[$stat];
        $current_gain = $card[$stat . "_change"];
        $new_stat_gain = max(-$base_stat, min(99 - $base_stat, $current_gain + $new_gain));
        return $new_stat_gain;
    }

    function multiply_own_power(?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        $power = $database->pull_power($card);
        $power_change = $this->get_multiply_change($power, $effect);
        $this->gain_power($power_change, $card, $effect, $database, $connection);
    }

    function get_multiply_change(?int $value, ?array $effect)
    {
        return $value * $effect["value"] - $value;
    }

    function multipy_own_cost(?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        $cost = $database->pull_cost($card);
        $cost_change = $this->get_multiply_change($cost, $effect);
        $query =
            "UPDATE card_instance
            SET cost_change = cost_change + " . $cost_change
            . " WHERE instance_id = " . $effect["instance_id"];
        $connection->query($query);
    }

    function multiply_power(?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        $targets_query =
            "WHERE game_id = " . $card["game_id"]
            . " AND player_id = " . $card["player_id"]
            . " AND zone_id = " . $effect["value_1"];
        $targets = $database->card_query($targets_query, $connection);
        if (sizeof($targets) == 0) {
            return;
        } else if ($effect["condition_1"] == "all_targets") {
            foreach ($targets as $target_card) {
                $this->multiply_card_power($target_card, $effect, $database, $connection);
            }
            return;
        }
        shuffle($targets);
        $this->multiply_card_power($targets[0], $effect, $database, $connection);
    }

    function multiply_card_power(?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        $effect = $this->lock_effect_to_card($card, $effect);
        $this->multiply_own_power($card, $effect, $database, $connection);
    }

    function spawn_card(?array $card, ?array $effect, ?CardMovement $card_movement, ?Database $database, ?mysqli $connection, ?int $cost_change = 0, ?int $power_change = 0)
    {
        $amount = 1;
        $zone_id = 2;
        $game_id = $card["game_id"];
        $player_id = $card["player_id"];
        switch ($effect["restriction"]) {
            case "to_opponent":
                $card["player_id"] = $database->get_opponent($game_id, $player_id, $connection);
                break;
        }
        foreach ([
            [$effect["condition_1"], $effect["value_1"]],
            [$effect["condition_2"], $effect["value_2"]]
        ]
            as $condition) {
            $value = $condition[1];
            switch ($condition[0]) {
                case "amount":
                    $amount = $value;
                    break;
                case "location":
                    $zone_id = $value;
                    break;
                case "power_change":
                    $power_change += $value;
                    break;
            }
        }
        $instance_id = $database->new_instance_id($connection);
        $card_slot = max(0, $database->highest_slot($card, $zone_id, $connection)) + 1;
        for ($i = 0; $i < $amount; $i++) {
            $this->instance_card($instance_id + $i, $zone_id, $card_slot + $i, $card, $effect, $connection, $cost_change, $power_change);
        }
        if ($zone_id == 0) {
            $card_movement->shuffle_deck($game_id, $player_id, $database, $connection);
        }
    }

    function instance_card(
        ?int $instance_id,
        ?int $zone_id,
        ?int $card_slot,
        ?array $card,
        ?array $effect,
        ?mysqli $connection,
        ?int $cost_change = 0,
        ?int $power_change = 0
    ) {
        $query =
            "INSERT INTO card_instance (instance_id, game_id, player_id, base_id, zone_id, card_slot, cost_change, power_change)
            VALUES (" . $instance_id . ", " . $card["game_id"] . ", " . $card["player_id"]
            . ", " . $effect["value"] . ", " . $zone_id . ", " . $card_slot . ", " . $cost_change . ", "
            . $power_change . ")";
        $connection->query($query);
    }

    function split_card(?array $card, ?array $effect, ?CardMovement $card_movement, ?Database $database, ?mysqli $connection)
    {
        if ($database->pull_cost($card) == 0) {
            return;
        }
        $splits = $effect["value"];
        $power_per_split = intdiv($card["power"], $splits);
        $cost_change = -$card["cost"];
        $power_change = $power_per_split - $card["power"];
        $effect["value"] = $card["base_id"];
        $effect["condition_1"] = "amount";
        $effect["value_1"] = $splits;
        $this->spawn_card($card, $effect, $card_movement, $database, $connection, $cost_change, $power_change);
    }

    function stat_flip(?array $card, ?array $effect, ?Database $database, ?mysqli $connection)
    {
        $cards = $this->get_cards($card, $effect, $database, $connection);
        foreach ($cards as $card) {
            $this->flip_stats($card, $database, $connection);
        }
    }

    function flip_stats(?array $card, ?Database $database, ?mysqli $connection)
    {
        $cost = $database->pull_cost($card);
        $power = $database->pull_power($card);
        $cost_change = $power - $cost;
        $power_change = $cost - $power;
        $effect = $this->lock_effect_to_card($card, []);
        $this->gain_cost($cost_change, $card, $effect, $database, $connection);
        $this->gain_power($power_change, $card, $effect, $database, $connection);
    }

    function steal_card(?array $card, ?array $effect, ?CardMovement $card_movement, ?Database $database, ?mysqli $connection)
    {
        $enemy_id = $database->get_opponent_card($card, $connection);
        $location = "field";
        $zone_id = 2;
        $order_by_clause = "";
        if ($effect["condition_1"] == "where_location_is") {
            switch ($effect["value_1"]) {
                case 1:
                    $location = "hand";
                    $zone_id = 1;
            }
        }
        switch ($effect["restriction"]) {
            case "highest_cost":
                $order_by_clause .=
                    "ORDER BY (cost + cost_change) DESC
                    LIMIT 1";
        }
        $query =
            "JOIN " . $database->card_table()
            . " ON base_id = id
            WHERE game_id = " . $card["game_id"]
            . " AND player_id = " . $enemy_id
            . " AND zone_id = " . $zone_id . " " . $order_by_clause;
        for ($i = 0; $i < $effect["value"]; $i++) {
            $cards = $database->card_query($query, $connection);
            if (sizeof($cards) > 0) {
                shuffle($cards);
                $card_id = $cards[0]["instance_id"];
                $card_movement->move_card($card_id, $location, $location, $database, $connection, $card["player_id"]);
            } else {
                break;
            }
        }
    }
}
