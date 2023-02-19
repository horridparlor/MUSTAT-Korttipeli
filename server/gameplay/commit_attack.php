<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: {$_SERVER["HTTP_ORIGIN"]}");
header("Access-Control-Max-Age: 5");

include("../system/Database.php");
include("../system/CardManager.php");
include("../system/CardMovement.php");
include("../system/EffectManager.php");

function commit_attack()
{
    $attacker_id = $_GET["attacker_id"];
    $target_id = $_GET["target_id"];
    $database = new Database();
    $card_manager = new CardManager();
    $connection = $database->connect();
    $attacker = $database->extrapolate_card($attacker_id, $connection);
    $target = $database->extrapolate_card($target_id, $connection);
    if (can_attack($attacker, $target)) {
        attack($attacker, $target, $card_manager, $database, $connection);
        echo 1;
    } else {
        echo 0;
    }
}

function can_attack(?array $attacker, ?array $target)
{
    if (not_on_field($attacker, $target)) {
        return false;
    }
    return true;
}

function not_on_field(?array $attacker, ?array $target)
{
    foreach ([$attacker, $target] as $card) {
        if ($attacker["zone_id"] != 2) {
            return true;
        }
    }
    return false;
}

function attack(?array $attacker, ?array $target, ?CardManager $card_manager, ?Database $database, ?mysqli $connection)
{
    $card_movement = new CardMovement();
    $effect_manager = new EffectManager();

    animate_attack($attacker, $target, $connection);
    $attacker_power = $database->pull_power($attacker);
    $target_power = $database->pull_power($target);

    $card_manager->process_attack($attacker_power, $target_power, $attacker, $target, $card_movement, $database, $connection);
    $card_manager->process_attack($target_power, $attacker_power, $target, $attacker, $card_movement, $database, $connection);
}

function animate_attack(?array $attacker, ?array $target, ?mysqli $connection)
{
    $query =
        "INSERT INTO attack (game_id, player_id, attacker_id, target_id)
        VALUES (" . $attacker["game_id"] . ", " . $target["player_id"]
        . ", " . $attacker["instance_id"] . ", " . $target["instance_id"] . ")";
    $connection->query($query);
}

commit_attack();
die();
