<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");

function get_accounts()
{
    $database = new Database();
    $connection = $database->connect();
    $keys = array(
        "id",
        "name"
    );
    $query =
        "FROM player";
    echo $database->json_query($keys, $query, $connection);
}

get_accounts();
die();
