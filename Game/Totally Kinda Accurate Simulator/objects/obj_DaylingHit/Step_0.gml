if (!instance_exists(owner) or owner.dead) {
    instance_destroy()
    exit
}

var o = owner
var cx = (o.bbox_left + o.bbox_right) / 2
var cy = (o.bbox_top + o.bbox_bottom) / 2

x = cx + o.facing * reach
y = cy
image_xscale = o.facing * sword_scale
image_yscale = sword_scale

if (!hit_done and floor(o.image_index) == 2) {
    hit_done = true

    var target = collision_rectangle(x - hit_half, y - hit_half, x + hit_half, y + hit_half, o.enemy_obj, false, true)

    if (target != noone and !target.dead and target.hp > 0) {
        var dmg = min(o.atk, target.hp)
        target.hp -= dmg

        if (target.hp <= 0) {
            o.hp = min(o.hp + 5, o.max_hp)
        }
    }
}