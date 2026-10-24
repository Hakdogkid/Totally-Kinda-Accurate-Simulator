// NOTE: Par_enemy's Step is intentionally not called (see Create event).
if (dead) exit;

// ===================== EATING (detected) =====================
// Obj_Food's collision event adds energy to any Par_enemy that touches it.
// Energy only goes UP when we ate, so each jump counts as food for the Multiplier.
var _gain = energy - prev_energy;
if (_gain > 0) food_held += max(1, round(_gain / 5));

// My centre (the sprite's origin is not the visual centre)
var _cx = (bbox_left + bbox_right) / 2;
var _cy = (bbox_top + bbox_bottom) / 2;

// ===================== DAMAGE DETECTION =====================
// Any hp loss since last frame = we were hurt.
if (hp < prev_hp)
{
    hit_flash = flash_time;

    // SPINY: nearest enemy in melee range loses hp
    var _attacker = nearest_alive(enemy_obj);
    if (_attacker != noone)
    {
        var _ax = (_attacker.bbox_left + _attacker.bbox_right) / 2;
        var _ay = (_attacker.bbox_top + _attacker.bbox_bottom) / 2;
        if (point_distance(_cx, _cy, _ax, _ay) <= spiny_range)
        {
            _attacker.hp -= spiny_damage;
        }
    }
}
if (hit_flash > 0) hit_flash--;

// ===================== DEATH =====================
if (hp <= 0)
{
    hp   = 0;
    dead = true;
    instance_destroy();
    exit;
}

// ===================== TIMERS =====================
if (shoot_cd > 0) shoot_cd--;
if (repro_cd > 0) repro_cd--;

if (reloading)
{
    reload_timer--;
    if (reload_timer <= 0)
    {
        reloading = false;
        ammo = ammo_max;
    }
}

// ===================== HUNGER =====================
hunger_timer++;
if (hunger_timer >= hunger_delay)
{
    hunger_timer = 0;
    energy = max(0, energy - 1);
}

if (energy <= 0)
{
    starve_timer++;
    if (starve_timer >= fps_val)
    {
        starve_timer = 0;
        hp -= 1;
        hit_flash = flash_time;   // flash on starvation too (no Spiny reaction)
    }
}
else
{
    starve_timer = 0;
}

// ===================== MULTIPLIER =====================
if (food_held >= repro_food_cost && energy >= repro_energy_cost
    && repro_cd <= 0 && instance_number(object_index) < pop_cap)
{
    food_held -= repro_food_cost;
    energy    -= repro_energy_cost;
    repro_cd   = repro_delay;

    repeat (irandom_range(1, 2))
    {
        if (instance_number(object_index) >= pop_cap) break;
        var _baby = instance_create_layer(x + irandom_range(-16, 16),
                                          y + irandom_range(-16, 16),
                                          layer, object_index);
        _baby.energy      = 5;
        _baby.prev_energy = 5;
    }
}

// ===================== TARGETING =====================
var _target = nearest_alive(enemy_obj);
var _tx = 0, _ty = 0, _dist = 99999;
if (_target != noone)
{
    _tx   = (_target.bbox_left + _target.bbox_right) / 2;
    _ty   = (_target.bbox_top + _target.bbox_bottom) / 2;
    _dist = point_distance(_cx, _cy, _tx, _ty);
}

// ----- Food claim -----
// Give up on our food if it's gone, or if another Pinkit claimed it before us.
if (food_target != noone && !instance_exists(food_target)) food_target = noone;

if (food_target != noone)
{
    var _me   = id;
    var _ft   = food_target;
    var _mine = claim_time;
    var _lost = false;
    with (Pinkits)
    {
        if (id != _me && food_target == _ft && (claim_time < _mine || (claim_time == _mine && id < _me)))
        {
            _lost = true;
        }
    }
    if (_lost) food_target = noone;
}

// Our claimed food, or else the nearest food nobody else is heading for
var _food = food_target;
if (_food == noone) _food = find_free_food();

var _fx = 0, _fy = 0;
if (_food != noone)
{
    _fx = (_food.bbox_left + _food.bbox_right) / 2;
    _fy = (_food.bbox_top + _food.bbox_bottom) / 2;
}

var _well_fed = (energy >= hunt_energy && food_held >= hunt_food);
var _go = false;     // do we have somewhere to walk this frame?
var _seeking = false; // are we walking to food this frame?
var _face_x = 0;     // which way to look (if combat)

if (_dist <= sight_range)
{
    // ---------- COMBAT (ranged kiting) ----------
    var _to_enemy = point_direction(_cx, _cy, _tx, _ty);
    _face_x = _tx - _cx;

    if (_dist < keep_distance)          // too close: back away
    {
        goal_x = x + lengthdir_x(96, _to_enemy + 180);
        goal_y = y + lengthdir_y(96, _to_enemy + 180);
        _go = true;
    }
    else if (_dist > shoot_range)       // too far: close the gap
    {
        goal_x = _tx;
        goal_y = _ty;
        _go = true;
    }

    // ===== RANGED: shoot =====
    if (_dist <= shoot_range && shoot_cd <= 0 && !reloading)
    {
        array_push(bullets, { bx: _cx, by: _cy, dir: _to_enemy, life: bullet_life, frame: 0 });
        shoot_cd = shoot_delay;
        ammo--;
        if (ammo <= 0)
        {
            reloading    = true;
            reload_timer = reload_time;
        }
    }
}
else if (_well_fed && _target != noone)
{
    // Well fed: go hunt the Daylings
    goal_x = _tx;
    goal_y = _ty;
    _go = true;
}
else if (energy < max_energy && _food != noone)
{
    // Hungry: go eat (touching Obj_Food triggers its collision event)
    _seeking = true;
    if (food_target != _food)
    {
        food_target = _food;          // claim it so other Pinkits go elsewhere
        claim_time  = current_time;
    }
    goal_x = _fx;
    goal_y = _fy;
    _go = true;
}
else
{
    // Wander to random spots
    wander_timer--;
    if (wander_timer <= 0 || point_distance(_cx, _cy, goal_x, goal_y) < 24)
    {
        goal_x = irandom_range(64, room_width  - 64);
        goal_y = irandom_range(64, room_height - 64);
        wander_timer = irandom_range(120, 240);
    }
    _go = true;
}

if (!_seeking) food_target = noone;   // not chasing food: let others have it

// ===================== MOVEMENT (walks around walls like the Daylings) =====================
var _ox = x, _oy = y;
var _was_overlapping = (instance_place(x, y, object_index) != noone);   // e.g. just born on top of someone

if (_go)
{
    mp_potential_step_object(goal_x, goal_y, spd, wall_obj);
}

// Never walk INTO another Pinkit: slide along one axis, or stay put
if (!_was_overlapping && blocked_at(x, y))
{
    var _nx = x, _ny = y;
    if (!blocked_at(_nx, _oy))      { x = _nx; y = _oy; }
    else if (!blocked_at(_ox, _ny)) { x = _ox; y = _ny; }
    else                            { x = _ox; y = _oy; }
}

// Already overlapping someone: push apart until free
if (_was_overlapping)
{
    var _o = instance_place(x, y, object_index);
    if (_o != noone)
    {
        var _d  = (_o.x == x && _o.y == y) ? irandom(359) : point_direction(_o.x, _o.y, x, y);
        var _px = x + lengthdir_x(2, _d);
        var _py = y + lengthdir_y(2, _d);
        if (!place_meeting(_px, _py, wall_obj)) { x = _px; y = _py; }
    }
}

moving = (x != _ox || y != _oy);
if (_go && !moving) wander_timer = 0;   // stuck: pick a new spot next frame

x = clamp(x, 16, room_width  - 16);
y = clamp(y, 16, room_height - 16);

// Facing: enemy while fighting, otherwise the way we walked
if (_face_x != 0)              facing = sign(_face_x);
else if (x - _ox != 0)         facing = sign(x - _ox);

// ===================== ANIMATION =====================
var _want = moving ? spr_walk : spr_idle;
if (sprite_index != _want)
{
    sprite_index = _want;
    image_index  = 0;
}
image_xscale = flip_with_direction ? facing * base_scale : base_scale;
image_yscale = base_scale;

// ===================== UPDATE BULLETS =====================
for (var i = array_length(bullets) - 1; i >= 0; i--)
{
    var _b = bullets[i];
    _b.bx += lengthdir_x(bullet_speed, _b.dir);
    _b.by += lengthdir_y(bullet_speed, _b.dir);
    _b.life--;
    _b.frame += arrow_anim_speed;

    // The whole arrow (tail to tip) is tested, so it disappears the moment it touches something
    var _hx = lengthdir_x(arrow_half_len, _b.dir);
    var _hy = lengthdir_y(arrow_half_len, _b.dir);
    var _hit = collision_line(_b.bx - _hx, _b.by - _hy, _b.bx + _hx, _b.by + _hy, enemy_obj, false, true);

    if (_hit != noone)
    {
        // only hurts if the enemy is still alive; the arrow is used up either way
        if (!_hit.dead) _hit.hp -= bullet_damage;   // Par_enemy's Step handles the death
        array_delete(bullets, i, 1);
    }
    else if (_b.life <= 0
          || _b.bx < 0 || _b.bx > room_width || _b.by < 0 || _b.by > room_height
          || collision_line(_b.bx - _hx, _b.by - _hy, _b.bx + _hx, _b.by + _hy, wall_obj, false, true) != noone)
    {
        array_delete(bullets, i, 1);
    }
}

// Remember values for next frame's detection
// (hunger/starvation are applied above, so they won't trigger Spiny or count as eating)
prev_hp     = hp;
prev_energy = energy;
