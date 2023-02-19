<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../../system/Database.php");

function load_cards()
{
    $database = new Database();
    $connection = $database->connect();
    $keys = ["id", "id"];
    $query =
        "FROM " . $database->card_table()
        . " WHERE id < 10000
        ORDER BY cost, power, finnish_name";
    echo $database->json_query($keys, $query, $connection);
}

load_cards();
die();
