<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");
include("../system/SessionConstants.php");

function check_id()
{
    $player_id = $_GET["player_id"];
    $game_id = $_GET["game_id"];
    $database = new Database();
    $connection = $database->connect();
    terminate_old_sessions($connection);
    if ($game_id == -1) {
        join_new_game($player_id, $database, $connection);
    } else {
        load_game($game_id, $player_id, $database, $connection);
    }
    $connection->close();
}

function join_new_game(?int $player_id, ?Database $database, ?mysqli $connection)
{
    $newest_game = get_newest_game($database, $connection);
    if ($newest_game == -1) {
        create_new_game($player_id, $database, $connection);
    } else {
        pick_starting_player($newest_game, $player_id, $database, $connection);
        join_game($player_id, $newest_game, $database, $connection);
    }
}

function terminate_old_sessions(?mysqli $connection)
{
    $session_constants = new SessionConstants();
    $query =
        "DELETE
        FROM game
        WHERE TIMESTAMPDIFF(SECOND, started_at, NOW()) >= " .
        $session_constants->MAX_GAME_TIME_SECONDS;
    $connection->query($query);
}

function pick_starting_player(?int $game_id, ?int $player_2, ?Database $database, ?mysqli $connection)
{
    $player_1 = $database->exact_query("player_id", $database->playmat_join, $connection);
    $players = [$player_1, $player_2];
    $query =
        "UPDATE game
        SET starting_player = " . $players[rand(0, 1)] .
        " WHERE id = " . $game_id;
    $connection->query($query);
}

function get_newest_game(?Database $database, ?mysqli $connection)
{
    $query =
        $database->playmat_join .
        "GROUP BY id
        HAVING COUNT(player_id) < 2";
    return $database->exact_query("id", $query, $connection);
}

function create_new_game(?int $player_id, ?Database $database, ?mysqli $connection)
{
    $game_table = "FROM game";
    $game_id = $database->exact_query("MAX(id)", $game_table, $connection) + 1;
    $query =
        "INSERT INTO game (id)
        values (" . $game_id . ")";
    $connection->query($query);
    join_game($player_id, $game_id, $database, $connection);
}

function join_game(?int $player_id, ?int $game_id, ?Database $database, ?mysqli $connection)
{
    $database->regrow_turn_left($game_id, $connection);
    $create_playmat =
        "INSERT INTO playmat
        (game_id, player_id)
        VALUES (" . $game_id . ", " . $player_id . ")";
    $queries = array_merge([$create_playmat], create_deck($game_id, $player_id, $database, $connection));
    foreach ($queries as $query) {
        $connection->query($query);
    }
    load_game($game_id, $player_id, $database, $connection);
}

function create_deck(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection)
{
    $queries = [];
    $instance_id = $database->new_instance_id($connection);
    $slot_identifiers = get_slot_identifiers();
    $decklist = json_decode($_GET["decklist"]);
    foreach (range(1, 12) as $slot) {
        $slot_identifier = $slot_identifiers[$slot - 1];
        $zone_id = $slot_identifier[0];
        $card_slot = $slot_identifier[1];
        $instance_card =
            "INSERT INTO card_instance (instance_id, game_id, player_id, base_id, variant_id, zone_id, card_slot)
            VALUES (" . $instance_id . " + " . $slot . ", " . $game_id . ", " . $player_id . ", " .
            $decklist[$slot - 1] . ", 0, " . $zone_id . ", " . $card_slot . ")";
        array_push($queries, $instance_card);
    }
    return $queries;
}

function get_slot_identifiers()
{
    $identifiers = [];
    foreach (range(1, 8) as $deck_slot) {
        array_push($identifiers, [0, $deck_slot]);
    }
    foreach (range(1, 4) as $hand_slot) {
        array_push($identifiers, [1, $hand_slot]);
    }
    shuffle($identifiers);
    return $identifiers;
}

function load_deck($player_id, $database)
{
    $default_deck = "[";
    for ($i = 0; $i < 18; $i++) {
        $default_deck .= "0,";
    }
    $default_deck = $database->remove_period($default_deck) . "]";
    return $default_deck;
}

function load_game(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection)
{
    $keys = ["id", "player_id", "starting_player", "turn_number"];
    $select_game =
        $database->playmat_join .
        "WHERE id = " . $game_id;
    $query =
        $select_game .
        " AND player_id != " . $player_id;
    $result = $database->json_query($keys, $query, $connection);
    if ($result == "[-1]") {
        die($database->exact_query("id", $select_game, $connection));
    }
    echo $result;
}

check_id();
die();
