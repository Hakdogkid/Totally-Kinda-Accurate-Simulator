// ---------- Body (red flash fades out after being hurt) ----------
var _col = c_white;
if (hit_flash > 0)
{
    _col = merge_color(c_white, flash_color, hit_flash / flash_time);
}
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, _col, 1);

// ---------- Arrows ----------
var _frames = sprite_get_number(spr_arrow);
for (var i = 0; i < array_length(bullets); i++)
{
    var _b = bullets[i];
    draw_sprite_ext(spr_arrow, floor(_b.frame) mod _frames, _b.bx, _b.by, arrow_scale, arrow_scale, _b.dir, c_white, 1);
}

// ---------- Bars above the head ----------
var _w  = 28;
var _bx = (bbox_left + bbox_right) / 2;
var _by = bbox_top - 12;

// HP bar
draw_set_color(c_black);
draw_rectangle(_bx - _w/2 - 1, _by, _bx + _w/2 + 1, _by + 4, false);
draw_set_color(c_red);
draw_rectangle(_bx - _w/2, _by + 1, _bx - _w/2 + _w * (hp / max_hp), _by + 3, false);

// Energy bar
draw_set_color(c_black);
draw_rectangle(_bx - _w/2 - 1, _by + 5, _bx + _w/2 + 1, _by + 8, false);
draw_set_color(c_yellow);
draw_rectangle(_bx - _w/2, _by + 6, _bx - _w/2 + _w * (energy / max_energy), _by + 7, false);

draw_set_color(c_white);
