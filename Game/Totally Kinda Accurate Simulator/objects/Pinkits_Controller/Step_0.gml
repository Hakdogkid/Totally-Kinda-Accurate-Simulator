// Spawn on the first frame so every spawner in the room already exists
if (!started)
{
    started = true;

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
}
