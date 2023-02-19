<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");

function update_gameplay()
{
    $game_id = $_GET["game_id"];
    $player_id = $_GET["player_id"];
    $database = new Database();
    $connection = $database->connect();
    $keys = $database->card_stats;
    $updates_query = get_zone_updates($game_id, $database);
    echo "[" . $database->json_query($keys, $updates_query, $connection) . ", "
        . get_attack_animations($game_id, $player_id, $database, $connection) . ", "
        . get_game_status($game_id, $player_id, $database, $connection) . "]";
}

function get_zone_updates(?int $game_id, ?Database $database)
{
    return "FROM " . $database->card_instance_join .
        "WHERE game_id = " . $game_id;
}

function get_attack_animations(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection)
{
    $keys = ["attacker_id", "target_id"];
    $identify_playmat =
        " WHERE game_id = " . $game_id
        . " AND player_id = " . $player_id;
    $get_query =
        "FROM attack" . $identify_playmat;
    $delete_query =
        "DELETE
        FROM attack" . $identify_playmat;
    $result = $database->json_query($keys, $get_query, $connection);
    $connection->query($delete_query);
    return $result;
}

function get_game_status(?int $game_id, ?int $player_id, ?Database $database, ?mysqli $connection)
{
    $keys = ["turn_number", "turn_lasted", "mana"];
    $query =
        "FROM game
        JOIN playmat
        ON id = game_id
        WHERE game_id =" . $game_id
        . " AND player_id = " . $player_id;
    return $database->json_query($keys, $query, $connection);
}

update_gameplay();
die();
