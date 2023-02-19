<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");

function load_zone()
{
    $game_id = $_GET["game_id"];
    $player_id = $_GET["player_id"];
    $zone_name = '"' . $_GET["zone"] . '"';
    $database = new Database();
    $connection = $database->connect();
    $keys = $database->card_stats;
    $query =
        "FROM" .
        $database->card_instance_join .
        "WHERE game_id = " . $game_id .
        " AND player_id = " . $player_id .
        " AND name = " . $zone_name .
        " ORDER BY card_slot";
    echo $database->json_query($keys, $query, $connection);
}

load_zone();
die();
