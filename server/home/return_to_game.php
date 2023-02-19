<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");
include("../system/SessionConstants.php");

function return_to_game()
{
    $user_id = $_GET["id"];
    $database = new Database();
    $session_constants = new SessionConstants();
    $connection = $database->connect();
    $query =
        $database->playmat_join .
        "WHERE player_id = " . $user_id .
        " AND turn_number < 7
        AND TIMESTAMPDIFF(SECOND, started_at, NOW()) < " .
        $session_constants->MAX_GAME_TIME_SECONDS;
    echo "[" . $database->exact_query("id", $query, $connection) . "]";
}

return_to_game();
die();
