/*
Pinkits  (Moquiring)

TRAITS:

Spiny      - Whenever an opponent hits you, they lose 3hp.
Ranged     - Projectiles deal 3 damage per contact (once per second, with reload time).
Multiplier - With 10 food and 5 energy, spawn 1-2 offspring.

Child of Par_enemy, so Pinkits share the base stats (hp 10, energy 18, spd 2) and eat
Obj_Food the same way the Daylings do (the food's collision event gives +5 energy).
Like the Daylings, a Pinkit dies as soon as its energy reaches 0.
Pinkits use their own Step because Par_enemy's Step plays Dayling_Death, and Pinkits
have no death animation (they just disappear).
*/

event_inherited();   // hp = max_hp = 10, energy/max_energy = 18, spd = 2, hunger_timer, dead

// =====================================================
//  SPRITES: swap these anytime (all sprites face RIGHT, origin Middle Center)
// =====================================================
spr_idle  = Pinkits_Idle;        // animation when standing still
spr_walk  = Pinkits_Walk;        // animation when moving
spr_arrow = Pinkits_Arrow;       // projectile sprite (points RIGHT at 0 degrees)

base_scale          = 1;       // sprites are 32x32 frame like the Daylings
arrow_scale         = 0.5;       // arrow size
arrow_anim_speed    = 0.25;      // arrow animation frames per step (ignored if 1 frame)
// half the arrow's drawn length: arrows hit the moment their TIP touches something
arrow_half_len      = (sprite_get_bbox_right(spr_arrow) - sprite_get_bbox_left(spr_arrow)) * arrow_scale / 2;
flip_with_direction = true;      // flip body sprite left/right

sprite_index = spr_idle;
image_speed  = 1;
facing       = 1;                // 1 = right, -1 = left
moving       = false;

// =====================================================
//  DAMAGE FLASH
// =====================================================
flash_color = c_red;
flash_time  = 12;                // frames the flash lasts
hit_flash   = 0;

// ---------- Who is who ----------
enemy_obj = obj_dayling;         // Daylings (Pagulayan)
food_obj  = Obj_Food;            // shared food
wall_obj  = Obj_wall;            // walls to path around

// ---------- Mortal / Hunger (base values come from Par_enemy) ----------
prev_hp     = hp;                // used to detect any damage (Spiny)
energy      = 10;                // start a bit hungry so they go looking for food
prev_energy = energy;            // used to detect eating
hunger_delay = game_get_speed(gamespeed_fps);   // same rate as Par_enemy: -1 energy per second

// ---------- Food ----------
food_held = 0;                   // bites eaten, saved up for the Multiplier

// ---------- TRAIT: SPINY ----------
spiny_damage = 3;                // attacker loses 3 hp
spiny_range  = 48;               // how close an attacker must be to count as a melee hit

// ---------- TRAIT: RANGED ----------
fps_val       = game_get_speed(gamespeed_fps);
bullets       = [];              // active projectiles live here
bullet_damage = 3;
bullet_speed  = 6;
bullet_life   = fps_val * 2;
shoot_delay   = fps_val;         // 1 shot per second
shoot_cd      = 0;
ammo_max      = 3;
ammo          = ammo_max;
reload_time   = fps_val * 2;
reload_timer  = 0;
reloading     = false;
shoot_range   = 160;
sight_range   = 220;

// ---------- TRAIT: MULTIPLIER ----------
pop_cap           = 30;          // max Pinkits alive at once
repro_food_cost   = 10;
repro_energy_cost = 5;
repro_delay       = fps_val * 3;
repro_cd          = 0;

// ---------- AI ----------
hunt_energy  = 12;               // well fed (energy and food) = go hunt Daylings
hunt_food    = 3;
wander_timer = 0;
goal_x       = x;
goal_y       = y;

// Food claims: a Pinkit "claims" the food it is walking to, so others pick a different one
food_target = noone;             // the food we are pathing to
claim_time  = 0;                 // when we claimed it (earlier claim wins a tie)

// Nearest enemy that is still alive (ignores Daylings in their death animation)
nearest_alive = function(_obj)
{
    var _best = noone;
    var _bd   = 1000000;
    var _px   = (bbox_left + bbox_right) / 2;
    var _py   = (bbox_top + bbox_bottom) / 2;
    with (_obj)
    {
        if (!dead)                        // ignore Daylings that are in their death animation
        {
            var _d = point_distance(_px, _py, (bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2);
            if (_d < _bd)
            {
                _bd   = _d;
                _best = id;
            }
        }
    }
    return _best;
};

// True if a Pinkit standing at (_x, _y) would overlap another Pinkit or a wall
blocked_at = function(_x, _y)
{
    return instance_place(_x, _y, object_index) != noone || place_meeting(_x, _y, wall_obj);
};

// Nearest food that no other Pinkit is already heading for
find_free_food = function()
{
    var _me   = id;
    var _px   = (bbox_left + bbox_right) / 2;
    var _py   = (bbox_top + bbox_bottom) / 2;
    var _best = noone;
    var _bd   = 1000000;

    with (food_obj)
    {
        var _food  = id;
        var _taken = false;

        with (Pinkits)
        {
            if (id != _me && food_target == _food)
            {
                _taken = true;
                break;
            }
        }

        if (!_taken)
        {
            var _d = point_distance(_px, _py, (bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2);
            if (_d < _bd)
            {
                _bd   = _d;
                _best = id;
            }
        }
    }
    return _best;
};
