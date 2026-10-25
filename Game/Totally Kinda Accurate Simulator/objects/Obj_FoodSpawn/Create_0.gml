randomize()

// ===================== FOOD SPAWNER SETTINGS =====================
start_amount    = 6;   // food dropped when the room starts
amount_per_wave = 5;    // <-- HOW MUCH FOOD spawns each wave
wave_seconds    = 6;    // seconds between waves
max_food        = 15;   // never more than this many Obj_Food in the room at once
spawn_radius    = 250;    // 0 = anywhere in the room, or e.g. 300 = within 300 px of this spawner
// =================================================================

wave_timer = wave_seconds * game_get_speed(gamespeed_fps);
started    = false;

// Drops _count food at random open spots (stops early at max_food)
spawn_food = function(_count)
{
    repeat (_count)
    {
        if (instance_number(Obj_Food) >= max_food) return;

        for (var t = 0; t < 30; t++)
        {
            var _px, _py;
            if (spawn_radius > 0)
            {
                var _a = random(360);
                var _r = random(spawn_radius);
                _px = x + lengthdir_x(_r, _a);
                _py = y + lengthdir_y(_r, _a);
            }
            else
            {
                _px = random_range(48, room_width  - 80);
                _py = random_range(48, room_height - 80);
            }
            _px = clamp(_px, 48, room_width  - 80);
            _py = clamp(_py, 48, room_height - 80);

            if (collision_rectangle(_px - 16, _py - 16, _px + 16, _py + 16, Obj_wall, false, true) != noone) continue;

            instance_create_layer(_px, _py, "Instances", Obj_Food);
            break;
        }
    }
};
