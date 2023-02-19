<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/CardManager.php");
include("../system/CardMovement.php");
include("../system/EffectManager.php");
include("../system/Database.php");
include("../system/PlaymatManager.php");

$TURN_LENGTH_SECOND = 40;

function pass_turn()
{
    $game_id = $_GET["game_id"];
    $player_id = $_GET["player_id"];
    $do_pass = $_GET["do_pass"];
    $database = new Database();
    $connection = $database->connect();
    if ($database->game_not_ended($game_id, $connection) or $database->game_not_begun($game_id, $connection)) {
        $database->failure();
        return;
    }
    $keys = ["turn_number"];
    $query =
        "FROM turn_passer
        JOIN game
        ON game_id = id
        WHERE game_id = " . $game_id
        . " AND player_id = " . $player_id;
    $result = $database->json_query($keys, $query, $connection);
    $success = $database->test_json_success(json_decode($result));
    if ($do_pass) {
        if (!$success) {
            commit_turn_pass($game_id, $player_id, $connection);
        }
        try_change_turn($game_id, $database, $connection);
        $database->success();
    } else {
        wear_turn($game_id, $database, $connection);
        $database->echo_result($success);
    }
}

function commit_turn_pass(?int $game_id, ?int $player_id, ?mysqli $connection)
{
    $query =
        "INSERT INTO turn_passer (game_id, player_id)
        VALUES (" . $game_id . ", " . $player_id . ")";
    $connection->query($query);
}

function try_change_turn(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $query =
        "FROM turn_passer
        WHERE game_id =" . $game_id
        . " GROUP BY game_id
        HAVING COUNT(player_id) = 2";
    if ($database->exact_test("game_id", $query, $connection)) {
        change_turn($game_id, $database, $connection);
    }
}

function change_turn(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $turn_number = get_turn_number($game_id, $database, $connection);
    $final_turn = 6;
    if ($turn_number > $final_turn) {
        return;
    }
    close_turn($game_id, $database, $connection);
    if ($turn_number == $final_turn) {
        end_game($game_id, $database, $connection);
        return;
    } else if ($turn_number > $final_turn) {
        return;
    }
    generate_turn_player_resources($game_id, $database, $connection);
}

function close_turn(?int $game_id, ?Database $database, ?mysqli $connection)
{
    trigger_end_of_turn_effects($game_id, $database, $connection);
    remove_turn_pass_commits($game_id, $database, $connection);
    $database->regrow_turn_left($game_id, $connection);
    update_turn_number($game_id, $connection);
}

function trigger_end_of_turn_effects(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $database->trigger_card_effects($game_id, -1, "end_of_turn", $connection);
}

function trigger_end_of_game_effect(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $database->trigger_card_effects($game_id, -1, "end_of_game", $connection);
}

function generate_turn_player_resources(?int $game_id, ?Database $database, ?mysqli $connection)
{
    set_mana($game_id, $database, $connection);
    draw_cards($game_id, $database, $connection);
}

function remove_turn_pass_commits(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $query =
        "DELETE
        FROM turn_passer
        WHERE game_id = " . $game_id;
    $connection->query($query);
}

function end_game(?int $game_id, ?Database $database, ?mysqli $connection)
{
    trigger_end_of_game_effect($game_id, $database, $connection);
    determine_winner($game_id, $database, $connection);
}

function determine_winner(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $card_manager = new CardManager();
    $playmat_manager = new PlaymatManager();
    $players = $database->get_players($game_id, $connection);
    $player_1_power = $playmat_manager->pull_power($game_id, $players[0], $database, $connection);
    $player_2_power = $playmat_manager->pull_power($game_id, $players[1], $database, $connection);
    $winning_player = -1;
    if ($player_1_power > $player_2_power) {
        $winning_player = $players[0];
    } else if ($player_2_power > $player_1_power) {
        $winning_player = $players[1];
    }
    $query =
        "UPDATE game
        SET winner = " . $winning_player
        . " WHERE $game_id = " . $game_id;
    $connection->query($query);
}

function update_turn_number(?int $game_id, ?mysqli $connection)
{
    $query =
        "UPDATE game
        SET turn_number = turn_number + 1
        WHERE id = " . $game_id;
    $connection->query($query);
}

function set_mana(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $turn_number = get_turn_number($game_id, $database, $connection);
    $update_query =
        "UPDATE playmat
        SET mana = " . $turn_number
        . " WHERE game_id = " . $game_id;
    $connection->query($update_query);
}

function get_turn_number(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $turn_query =
        "FROM game
        WHERE id = " . $game_id;
    return $database->exact_query("turn_number", $turn_query, $connection);
}

function draw_cards(?int $game_id, ?Database $database, ?mysqli $connection)
{
    $card_movement = new CardMovement();
    $players = $database->get_players($game_id, $connection);
    foreach ($players as $player_id) {
        $card_movement->draw_card($game_id, $player_id, $database, $connection);
    }
}

function wear_turn(?int $game_id, ?Database $database, ?mysqli $connection)
{
    global $TURN_LENGTH_SECOND;
    $identify_game =
        " WHERE id = " . $game_id;
    $turn_lasted_query =
        "FROM game" . $identify_game;
    $turn_lasted = $database->time_difference("turn_started_at", $turn_lasted_query, $connection);
    $wear_query =
        "UPDATE game
        SET turn_lasted = " . $turn_lasted . $identify_game;
    $connection->query($wear_query);
    $get_turn_lasted =
        "FROM game" . $identify_game;
    $turn_lasted = $database->exact_query("turn_lasted", $get_turn_lasted, $connection);
    if ($turn_lasted >= $TURN_LENGTH_SECOND) {
        change_turn($game_id, $database, $connection);
    }
}

pass_turn();
die();
