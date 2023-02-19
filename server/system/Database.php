<?php

class  Database
{
    var $card_instance_join =
    " card_instance
        INNER JOIN zone
        ON zone_id = zone.id ";
    var $card_stats = [
        "player_id", "instance_id", "base_id", "variant_id", "name",
        "cost_change", "power_change", "attacks"
    ];
    var $playmat_join = "FROM game
        JOIN playmat
        ON id = game_id ";

    function connect()
    {
        $servername = "tähän_serverin_osoite.fi";
        $username = "tähän_mysql_käyttäjätunnus_mulla_sama_kuin_taulun_nimi";
        $password = "sitten_mysql_käyttäjän_salasana";
        $connection = new mysqli($servername, $username, $password, $username);
        if ($connection->connect_error) {
            die("Failed to connect DATABASE: " . $connection->connect_error);
        }
        return $connection;
    }

    function card_table()
    {
        return "dev_card";
    }

    function card_effect_table()
    {
        return $this->card_table() . "_effect";
    }

    function safe_query(
        ?array $keys,
        ?string $base_query,
        ?mysqli $connection,
        ?bool $do_debug = false
    ) {
        $query = $this->build_full_query($keys, $base_query);
        if ($do_debug) {
            echo $query . ";\n";
        }
        $result = $connection->query($query);
        if (mysqli_num_rows($result) > 0) {
            return $result;
        } else {
            return -1;
        }
    }

    function query_failed($result)
    {
        return is_int($result) && $result == -1;
    }

    function exact_query($key, $query, $connection, ?bool $do_debug = false)
    {
        $result = $this->safe_query([$key], $query, $connection, $do_debug);
        if ($this->query_failed($result)) {
            return -1;
        }
        while ($row = mysqli_fetch_assoc($result)) {
            return $row[$key];
        }
        return -1;
    }

    function exact_test($key, $query, $connection, ?bool $do_debug = false)
    {
        return $this->test_exact_success($this->exact_query($key, $query, $connection, $do_debug));
    }

    function test_exact_success($result)
    {
        return $result != -1;
    }

    function json_query(
        ?array $keys,
        ?string $query,
        ?mysqli $connection,
        ?bool $do_debug = false
    ) {
        $result = $this->safe_query($keys, $query, $connection, $do_debug);
        if (is_int($result)) {
            return "[-1]";
        }
        $json_result = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $new_item = [];
            foreach ($keys as $key) {
                array_push($new_item, $row[$key]);
            }
            array_push($json_result, $new_item);
        }
        return json_encode($json_result);
    }

    function test_json_success(?array $result)
    {
        return !is_int($result[0]);
    }

    function echo_result(?bool $success)
    {
        if ($success) {
            $this->success();
        } else {
            $this->failure();
        }
    }

    function success()
    {
        echo "[1]";
    }

    function failure()
    {
        echo "[-1]";
    }

    function build_full_query(?array $keys, ?string $base_query)
    {
        $super = "";
        $from_part = " ";
        $select_part = "SELECT ";
        foreach ($keys as $key) {
            $select_part .= $super . $key . ",";
        }
        return $this->remove_period($select_part) . $from_part . $base_query;
    }

    function remove_period($string)
    {
        return rtrim($string, ",");
    }

    function extrapolate_card(?int $instance_id, ?mysqli $connection)
    {
        $query =
            "SELECT instance_id, game_id, player_id, base_id, zone_id,
            card_slot, cost, cost_change, power, power_change, attacks
            FROM card_instance
            JOIN " . $this->card_table()
            . " ON base_id = id
            WHERE instance_id = " . $instance_id;
        $result = $connection->query($query);
        return mysqli_fetch_assoc($result);
    }

    function get_players(?int $game_id, ?mysqli $connection)
    {
        $query =
            "SELECT player_id
            FROM playmat
            WHERE game_id = " . $game_id;
        $result = $connection->query($query);
        return [mysqli_fetch_assoc($result)["player_id"], mysqli_fetch_assoc($result)["player_id"]];
    }

    function get_opponent(?int $game_id, ?int $player_id, $connection)
    {
        foreach ($this->get_players($game_id, $connection) as $player) {
            if ($player != $player_id) {
                return $player;
            }
        }
    }

    function get_opponent_card(?array $card, $connection)
    {
        return $this->get_opponent($card["game_id"], $card["player_id"], $connection);
    }

    function game_not_ended(?int $game_id, ?mysqli $connection)
    {
        $query =
            "FROM game
            WHERE winner IS NOT NULL
            AND id = " . $game_id;
        return $this->test_exact_success($this->exact_query("id", $query, $connection));
    }

    function get_cards(?int $game_id, ?mysqli $connection, ?String $extra_condition = "")
    {
        $query =
            "WHERE game_id = " . $game_id . " " . $extra_condition;
        return $this->card_query($query, $connection);
    }

    function card_query(?String $query, ?mysqli $connection)
    {
        $cards = [];
        $select_part = "SELECT " . "instance_id"
            . " FROM card_instance ";
        $card_ids = $connection->query($select_part . $query);
        if (mysqli_num_rows($card_ids) == 0) {
            return $cards;
        }
        while ($row = mysqli_fetch_assoc($card_ids)) {
            array_push($cards, $this->extrapolate_card($row["instance_id"], $connection));
        }
        return $cards;
    }

    function get_card_effects(?int $game_id, ?int $player_id, ?int $card_id, ?String $trigger, ?mysqli $connection, ?string $affects_trigger = "")
    {
        $cards = [];
        $extra_condition = "";
        if ($affects_trigger != "") {
            $extra_condition = $condition = "AND effect = \"" . $affects_trigger . "\"";
        }
        $query =
            "SELECT trigger_condition, instance_id, effect, value, restriction, condition_1,
            value_1, condition_2, value_2"
            . $this->identify_effect($game_id, $trigger) . $extra_condition . $this->where_player_is($player_id);
        if ($card_id >= 0) {
            $query .= " AND instance_id = " . $card_id;
        }
        $result = $connection->query($query);
        if (mysqli_num_rows($result) == 0) {
            return $cards;
        }
        while ($row = mysqli_fetch_assoc($result)) {
            array_push($cards, $row);
        }
        return $cards;
    }

    function where_player_is($player_id)
    {
        return
            " AND (condition_1 IS NULL
            OR condition_1 != \"when_player\"
                OR (value_1 = 1 AND player_id = " . $player_id
            . ") OR player_id != " . $player_id . ")";
    }

    function identify_effect(?int $game_id, ?string $trigger)
    {
        return
            " FROM card_instance
            JOIN zone
            ON zone_id = zone.id
            JOIN " . $this->card_table()
            . " ON base_id = " . $this->card_table() . ".id
            JOIN " . $this->card_effect_table()
            . " ON base_id = owner_id
            WHERE game_id = " . $game_id
            . " AND trigger_condition = \"" . $trigger . "\""
            . " AND (trigger_zone = zone_id OR (trigger_zone = 4 AND zone_id != 3) )";
    }

    function trigger_card_effects(?int $game_id, ?int $player_id, ?String $trigger, ?mysqli $connection, ?int $card_id = -1, ?int $power = 0)
    {
        $effect_manager = new EffectManager();
        if ($this->effects_negated($game_id, $trigger, $connection)) {
            return;
        }
        $effects = $this->get_card_effects($game_id, $player_id, $card_id, $trigger, $connection);
        $trigger_times = $this->get_trigger_times($game_id, $trigger, $connection);
        foreach ($effects as $effect) {
            $effect["power"] = $power;
            foreach (range(1, $trigger_times) as $i) {
                $effect_manager->trigger_effect($effect, $this, $connection);
            }
        }
    }

    function trigger_card_effects_card(?array $card, ?String $trigger, ?mysqli $connection, ?int $power)
    {
        $this->trigger_card_effects($card["game_id"], $card["player_id"], $trigger, $connection, $card["instance_id"], $power);
    }

    function effects_negated(?int $game_id, ?String $trigger, ?mysqli $connection)
    {
        return $this->has_effect($game_id, "negate_effects", -1, $connection, $trigger);
    }

    function has_effect(?int $game_id, ?String $trigger, ?int $card_id, ?mysqli $connection, ?string $affects_trigger = "")
    {
        return sizeof($this->get_card_effects($game_id, -1, -1, $trigger, $connection, $affects_trigger)) > 0;;
    }

    function get_trigger_times(?int $game_id, ?String $trigger, ?mysqli $connection)
    {
        $trigger_times = 1;
        $extra_trigger_effects = $this->get_card_effects($game_id, -1, -1, "multiply_effect", $connection, $trigger);
        foreach ($extra_trigger_effects as $effect) {
            $trigger_times *= $effect["value"];
        }
        return $trigger_times;
    }

    function pull_cost(?array $card)
    {
        return $card["cost"] + $card["cost_change"];
    }

    function pull_power(?array $card)
    {
        return $card["power"] + $card["power_change"];
    }

    function game_not_begun(?int $game_id, ?mysqli $connection)
    {
        $query =
            "FROM game
            JOIN playmat
            on id = game_id
            WHERE game_id = " . $game_id
            . " GROUP BY id
            HAVING COUNT(player_id) = 2";
        return $this->exact_query("id", $query, $connection) == -1;
    }

    function time_difference(?String $time_key, ?String $query, ?mysqli $connection)
    {
        $key = "time";
        $select_part = "SELECT TIMESTAMPDIFF (SECOND, " . $time_key
            . ", NOW()) as " . $key . " ";
        return $this->deep_query($key, $select_part . $query, $connection);
    }

    function deep_query(?String $key, ?String $query, ?mysqli $connection)
    {
        return mysqli_fetch_assoc($connection->query($query))[$key];
    }

    function regrow_turn_left(?int $game_id, ?mysqli $connection)
    {
        $query =
            "UPDATE game
        SET turn_started_at = NOW()
        WHERE id = " . $game_id;
        $connection->query($query);
    }

    function zone_filled(?int $zone_id, ?array $card, ?mysqli $connection, ?int $freed_vacancy = 0)
    {
        return $this->zone_filled_idp($zone_id, $this->card_to_idp($card), $connection, $freed_vacancy);
    }

    function card_to_idp(?array $card)
    {
        return
            " WHERE game_id = " . $card["game_id"] .
            " AND player_id = " . $card["player_id"] . " ";
    }

    function zone_filled_idp(?int $zone_id, $identify_playmat, ?mysqli $connection, ?int $freed_vacancy = 0)
    {
        $total_vacancy =
            "FROM zone
        WHERE id = " . $zone_id;
        $zone_vacancy = $this->exact_query("vacancy", $total_vacancy, $connection);
        $vacancy_used = $this->highest_slot_idp($identify_playmat, $zone_id, $connection);
        if ($zone_vacancy != -1 and $vacancy_used - $freed_vacancy >= $zone_vacancy) {
            return true;
        }
        return false;
    }

    function highest_slot(?array $card, ?int $zone_id, ?mysqli $connection, ?int $card_id = -1)
    {
        return $this->highest_slot_idp($this->card_to_idp($card), $zone_id, $connection, $card_id);
    }

    function highest_slot_idp(?String $identify_playmat, ?int $zone_id, ?mysqli $connection, ?int $card_id = -1)
    {
        $query =
            "FROM card_instance" .
            $identify_playmat .
            "AND zone_id = " . $zone_id .
            " AND instance_id != " . $card_id .
            " ORDER BY card_slot DESC";
        return $this->exact_query("card_slot", $query, $connection);
    }

    function new_instance_id(?mysqli $connection)
    {
        $query =
            "FROM card_instance
            ORDER BY instance_id DESC";
        return $this->exact_query("instance_id", $query, $connection) + 1;
    }

    function get_zone_id(?string $zone_name, ?mysqli $connection)
    {
        $query =
            "FROM zone
        WHERE name = " . "\"" . $zone_name . "\"";
        return $this->exact_query("id", $query, $connection);
    }
}
