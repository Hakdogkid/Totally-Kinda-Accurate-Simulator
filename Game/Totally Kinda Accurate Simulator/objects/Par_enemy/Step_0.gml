if (!dead) {
    hunger_timer++
    if (hunger_timer >= game_get_speed(gamespeed_fps)) {
        hunger_timer = 0
        energy -= 1
    }

    if (hp <= 0 or energy <= 0) {
        
        sprite_index = Dayling_Death
        image_index = 0
        image_speed = 1
		dead = true
    }
}