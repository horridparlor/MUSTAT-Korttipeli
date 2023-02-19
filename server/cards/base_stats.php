<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");

function load_base_stats()
{
    $base_id = $_GET["base_id"];
    $database = new Database();
    $connection = $database->connect();
    $keys = ["finnish_name", "cost", "power", "finnish_effects"];
    $query =
        "FROM " . $database->card_table()
        . " WHERE id = " . $base_id;
    echo $database->json_query($keys, $query, $connection);
}

load_base_stats();
die();
