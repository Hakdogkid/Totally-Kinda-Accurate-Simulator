// Spawns the Pinkits (Player 2) and, optionally, keeps food coming.
// Doesn't change Obj_Spawner / Obj_SpawnerP2 / Obj_FoodSpawn: it only reads where
// they are placed in the room.

start_per_spawner = 1;            // Pinkits spawned at each Obj_SpawnerP2 on room start

// ----- Food top-up (set to false if the food spawner gets its own code later) -----
food_enabled = true;
food_cap     = 20;                // max Obj_Food in the room at once
food_delay   = game_get_speed(gamespeed_fps) * 3;   // one new food every 3 seconds
food_timer   = 0;

// Drops a food pile near an Obj_FoodSpawn (or anywhere open if there isn't one)
spawn_food = function()
{
    for (var t = 0; t < 20; t++)
    {
        var _px, _py;
        if (instance_number(Obj_FoodSpawn) > 0)
        {
            var _s = instance_find(Obj_FoodSpawn, irandom(instance_number(Obj_FoodSpawn) - 1));
            _px = _s.x + irandom_range(-200, 200);
            _py = _s.y + irandom_range(-160, 160);
        }
        else
        {
            _px = irandom_range(48, room_width  - 80);
            _py = irandom_range(48, room_height - 80);
        }

        _px = clamp(_px, 48, room_width  - 80);
        _py = clamp(_py, 48, room_height - 80);

        if (collision_rectangle(_px, _py, _px + 32, _py + 32, Obj_wall, false, true) == noone)
        {
            instance_create_layer(_px, _py, "Instances", Obj_Food);
            return;
        }
    }
};

// ----- Spawn the Pinkits -----
if (instance_number(Obj_SpawnerP2) > 0)
{
    with (Obj_SpawnerP2)
    {
        repeat (other.start_per_spawner)
        {
            instance_create_layer(x + irandom_range(-16, 16), y + irandom_range(-16, 16), "Instances", Pinkits);
        }
    }
}
else
{
    // no P2 spawners placed: fall back to the right side of the room
    repeat (start_per_spawner * 3)
    {
        instance_create_layer(room_width - 160, irandom_range(100, room_height - 100), "Instances", Pinkits);
    }
}
