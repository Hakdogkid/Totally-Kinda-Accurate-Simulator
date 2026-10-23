// Food respawns over time so the colonies have something to eat
if (food_enabled)
{
    food_timer++;
    if (food_timer >= food_delay)
    {
        food_timer = 0;
        if (instance_number(Obj_Food) < food_cap) spawn_food();
    }
}
