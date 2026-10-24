event_inherited()

if (attacking) {
    attacking = false
    sprite_index = Dayling_Idle

    if (instance_exists(attack_hitbox)) {
        instance_destroy(attack_hitbox)
    }
    attack_hitbox = noone
}