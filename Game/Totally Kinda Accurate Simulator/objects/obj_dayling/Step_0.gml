event_inherited()
if (dead) exit

if (attack_cd > 0) {
    attack_cd--
}

if (attacking) {
    exit
}

var target = instance_nearest(x, y, enemy_obj)
var target_dist = 99999
if (target != noone) {
    target_dist = point_distance(x, y, target.x, target.y)
}

var food = instance_nearest(x, y, Obj_Food)
var food_x = 0
var food_y = 0
if (food != noone) {
    food_x = (food.bbox_left + food.bbox_right) / 2
    food_y = (food.bbox_top + food.bbox_bottom) / 2
}

if (energy < hungry_energy and food != noone) {
    state = DayState.HUNGRY
}
else if (state == DayState.HUNGRY and energy < recover_energy and food != noone) {

}
else if (target != noone and target_dist <= sight_range) {
    state = DayState.HUNT
}
else {
    state = DayState.FORAGE
}

can_eat = (state != DayState.HUNT)

mp_potential_settings(30, 10, 10, true)

switch (state) {

    case DayState.HUNGRY:
        mp_potential_step_object(food_x, food_y, spd, Obj_wall)
        sprite_index = Dayling_Running
        break

    case DayState.FORAGE:
        if (energy < max_energy and food != noone) {
            mp_potential_step_object(food_x, food_y, spd, Obj_wall)
            sprite_index = Dayling_Running
        } else {
            sprite_index = Dayling_Idle
        }
        break

    case DayState.HUNT:
        facing = (target.x >= x) ? 1 : -1

        if (target_dist > attack_range) {
            mp_potential_step_object(target.x, target.y, spd, Obj_wall)
            sprite_index = Dayling_Running
        }
        else if (attack_cd <= 0) {
            attacking = true
            attack_cd = game_get_speed(gamespeed_fps)
            sprite_index = Dayling_Attack
			
			attack_hitbox = instance_create_layer(x, y, layer, obj_DaylingHit)
            attack_hitbox.owner = id
			
            image_index = 0
            image_speed = 1


        }
        else {
            sprite_index = Dayling_Idle
        }
        break
}