<?php

header("Content-Type: audio/mpeg");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");

function load_sound()
{
    $card_id = $_GET["base_id"];
    $variant_id = $_GET["variant_id"];
    $zone = $_GET["zone"];
    $database = new Database();
    $connection = $database->connect();
    $zone_id = $database->get_zone_id($zone, $connection);
    $query =
        "FROM sound
        WHERE card_id = " . $card_id
        . " AND variant_id = " . $variant_id
        . " AND zone_id = " . $zone_id;
    echo $database->exact_query("sound_data", $query, $connection);
}

load_sound();
die();
