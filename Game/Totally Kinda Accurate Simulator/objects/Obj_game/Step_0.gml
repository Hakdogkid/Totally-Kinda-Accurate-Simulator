// count only the living ones
dayling_count = 0
pinkit_count = 0

with (obj_dayling) {
    if (!dead) other.dayling_count++
}
with (Pinkits) {
    if (!dead) other.pinkit_count++
}

if (!both_spawned) {
    if (dayling_count > 0 and pinkit_count > 0) {
        both_spawned = true
    }
    exit
}

if (winner == "") {
    if (dayling_count == 0 and pinkit_count == 0) {
        winner = "DRAW"
    }
    else if (dayling_count == 0) {
        winner = "PINKITS WINS"
    }
    else if (pinkit_count == 0) {
        winner = "DAYLINGS WINS"
    }

    if (winner != "") {
        end_timer = 3 * game_get_speed(gamespeed_fps)
    }
}
else {
    end_timer--
    if (end_timer <= 0) {
        game_end()
    }
}