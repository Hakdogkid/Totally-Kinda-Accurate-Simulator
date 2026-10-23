event_inherited()
if (dead) exit

var food = instance_nearest(x, y, Obj_Food)

if (energy < max_energy and food != noone) {
    mp_potential_step_object(food.x, food.y, spd, Obj_wall)
    sprite_index = Dayling_Running
} else {
    sprite_index = Dayling_Idle
}