<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");
include("../system/CardMovement.php");
include("../system/EffectManager.php");

function move_card()
{
    $card_id = $_GET["card_id"];
    $from_name = $_GET["from"];
    $to_name = $_GET["to"];
    $database = new Database();
    $connection = $database->connect();
    $card_movement = new CardMovement();
    if ($from_name == "null") {
        die();
    }
    echo $card_movement->move_card($card_id, $from_name, $to_name, $database, $connection);
}

move_card();
die();
