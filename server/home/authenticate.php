<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");
include("../system/SessionConstants.php");

function authenticate()
{
    $game_id = $_GET["game_id"];
    $player_id = $_GET["player_id"];
    $password = $_GET["key"];
    $is_first = $_GET["is_first"];
    $database = new Database();
    $connection = $database->connect();
    $condition = " WHERE id = " . $player_id;
    $query =
        "FROM player" . $condition;
    $current_password = $database->exact_query("password", $query, $connection);
    if (old_version($database, $connection)) {
        echo_push(-2);
    } else if ($is_first) {
        $update_password =
            "UPDATE player
            SET password = " . $password . $condition;
        $connection->query($update_password);
        terminate_old_sessions($connection);
        echo_push($password);
    } else if ($is_first) {
        echo_push($password);
    } else if (game_ended($game_id, $database, $connection)) {
        echo_push(-1);
    } else {
        echo_push($current_password);;
    }
    $connection->close();
}

function old_version(?Database $database, ?mysqli $connection)
{
    $version = $_GET["version"];
    $current_version_query =
        "FROM game_status
        ORDER BY version DESC";
    $current_version = $database->exact_query("version", $current_version_query, $connection);
    return $version != $current_version;
}

function echo_push(?int $value)
{
    echo "[" . $value . "]";
}

function game_ended(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $query =
        "FROM game
        WHERE id = " . $game_id;
    $response = $database->exact_query("id", $query, $connection);
    return !is_array($response) && $game_id != $response;
}

function terminate_old_sessions(?mysqli $connection)
{
    $session_constants = new SessionConstants();
    $query =
        "DELETE
        FROM game
        WHERE TIMESTAMPDIFF(SECOND, started_at, NOW()) >= " .
        $session_constants->MAX_GAME_TIME_SECONDS;
    $connection->query($query);
}

authenticate();
die();
