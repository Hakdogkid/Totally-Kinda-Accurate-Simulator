draw_self()

/*var state_names = ["HUNGRY", "FORAGE", "HUNT"]
draw_text(x - 16, y - 34, state_names[state])*/


var _w  = 28;
var _bx = (bbox_left + bbox_right) / 2;
var _by = bbox_top - 12;


draw_set_color(c_black);
draw_rectangle(_bx - _w/2 - 1, _by, _bx + _w/2 + 1, _by + 4, false);
draw_set_color(c_red);
draw_rectangle(_bx - _w/2, _by + 1, _bx - _w/2 + _w * (hp / max_hp), _by + 3, false);


draw_set_color(c_black);
draw_rectangle(_bx - _w/2 - 1, _by + 5, _bx + _w/2 + 1, _by + 8, false);
draw_set_color(c_yellow);
draw_rectangle(_bx - _w/2, _by + 6, _bx - _w/2 + _w * (energy / max_energy), _by + 7, false);

draw_set_color(c_white);