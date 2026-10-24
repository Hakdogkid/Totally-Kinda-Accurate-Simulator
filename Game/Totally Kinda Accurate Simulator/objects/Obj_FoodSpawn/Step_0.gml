// First frame: the starting food (done here so every wall in the room already exists)
if (!started)
{
    started = true;
    spawn_food(start_amount);
}

// Then one wave every wave_seconds
wave_timer--;
if (wave_timer <= 0)
{
    wave_timer = wave_seconds * game_get_speed(gamespeed_fps);
    spawn_food(amount_per_wave);
}
