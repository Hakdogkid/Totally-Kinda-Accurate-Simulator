var w = display_get_gui_width()
var h = display_get_gui_height()

draw_set_halign(fa_center)
draw_set_valign(fa_top)
draw_set_color(c_white)


draw_text_transformed(w * 0.25, 16, "DAYLINGS", 2, 2, 0)
draw_text_transformed(w * 0.5, 16, "VS", 2, 2, 0)
draw_text_transformed(w * 0.75, 16, "PINKITS", 2, 2, 0)


draw_text_transformed(w * 0.25, 56, string(dayling_count), 3, 3, 0)
draw_text_transformed(w * 0.75, 56, string(pinkit_count), 3, 3, 0)


if (winner != "") {
    draw_set_valign(fa_middle)
    draw_text_transformed(w * 0.5, h * 0.5, winner, 4, 4, 0)
}

draw_set_halign(fa_left)
draw_set_valign(fa_top)