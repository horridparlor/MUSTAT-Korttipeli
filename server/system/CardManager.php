<?php

class  CardManager
{
    function process_attack(
        ?int $power,
        ?int $attacker_power,
        ?array $card,
        ?array $attacker,
        ?CardMovement $card_movement,
        ?Database $database,
        ?mysqli $connection
    ) {
        $new_power = $this->take_damage($power, $attacker_power, $card, $connection);
        if ($new_power == 0) {
            $this->kill_card($power, $card, $card_movement, $database, $connection);
            $database->trigger_card_effects_card($attacker, "got_kill", $connection, $card["power"]);
        }
    }

    function take_damage(?int $power, ?int $attacker_power, ?array $card, ?mysqli $connection)
    {
        $new_power = $this->get_new_power($power, $attacker_power);
        $query =
            "UPDATE card_instance
            SET power_change = power_change + " . $new_power - $power .
            " WHERE instance_id = " . $this->pull_id($card);
        $connection->query($query);
        return $new_power;
    }

    function get_new_power(?int $power, ?int $attacker_power)
    {
        if ($attacker_power <= 0) {
            return $power;
        }
        $new_power = $power - $attacker_power;
        if ($new_power < 0) {
            $new_power = 0;
        }
        return $new_power;
    }

    function pull_id(?array $card)
    {
        return $card["instance_id"];
    }

    function kill_card(?int $power, ?array $card, ?CardMovement $card_movement, ?Database $database, ?mysqli $connection)
    {
        $database->trigger_card_effects($card["game_id"], -1, "death", $connection, $this->pull_id($card));
        $database->trigger_card_effects($card["game_id"], $card["player_id"], "whenever_death", $connection);
        $card_movement->move_card($this->pull_id($card), "field", "grave", $database, $connection);
    }
}
