<?php

header("Content-Type: image/png");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");

function load_variant()
{
    $card_id = $_GET["base_id"];
    $variant_id = $_GET["variant_id"];
    $scale = $_GET["scale"];
    $database = new Database();
    $connection = $database->connect();
    $image_key = "small";
    if ($scale == 4) {
        $image_key = "big";
    }
    $query =
        "FROM variant
        WHERE card_id = " . $card_id .
        " AND variant_id = " . $variant_id;
    echo $database->exact_query($image_key . "_image", $query, $connection);
}

load_variant();
die();
