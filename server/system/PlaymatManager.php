<?php

class  PlaymatManager
{
    function get_cards(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection)
    {
        $query =
            "FROM card_instance
            WHERE game_id = " . $game_id
            . " AND player_id = " . $player_id
            . " AND zone_id = 2";
        $cards = json_decode($database->json_query(["instance_id"], $query, $connection));
        if ($database->test_json_success($cards)) {
            return $cards;
        }
        return [];
    }

    function get_all_cards(?int $game_id, ?array $players, ?Database $database, ?mysqli $connection)
    {
        return array_merge(
            $this->get_cards($game_id, $players[0], $database, $connection),
            $this->get_cards($game_id, $players[1], $database, $connection)
        );
    }

    function pull_power(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection)
    {
        $power = 0;
        $cards = $this->get_cards($game_id, $player_id, $database, $connection);
        foreach ($cards as $card) {
            $card = $database->extrapolate_card($card[0], $connection);
            $power += $database->pull_power($card);
        }
        return $power;
    }
}
