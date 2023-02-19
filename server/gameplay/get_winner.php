<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");

function get_winner()
{
    $game_id = $_GET["game_id"];
    $database = new Database();
    $connection = $database->connect();
    $query =
        "FROM game
        WHERE id = " . $game_id;
    echo $database->exact_query("winner", $query, $connection);
}

get_winner();
die();
