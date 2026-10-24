if (!instance_exists(owner) or owner.dead) {
    instance_destroy()
    exit
}


var o = owner
var cx = (o.bbox_left + o.bbox_right) / 2
var cy = (o.bbox_top + o.bbox_bottom) / 2
x = cx + o.facing * 20
y = cy


if (!hit_done and floor(o.image_index) == 2) {
    hit_done = true

    var target = collision_rectangle(x - 20, y - 20, x + 20, y + 20, o.enemy_obj, false, true)

    if (target != noone and !target.dead) {
        target.hp -= o.atk

        if (target.hp <= 0) {
            o.hp = min(o.hp + 5, o.max_hp)
        }
    }
}