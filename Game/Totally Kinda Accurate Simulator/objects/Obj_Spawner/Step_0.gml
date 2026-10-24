if (!started) {
    started = true

    var total = instance_number(Obj_Spawner)

    while (instance_number(obj_dayling) < max_spawn) {
        var s = instance_find(Obj_Spawner, irandom(total - 1))
        instance_create_layer(s.x + irandom_range(-48, 48), s.y + irandom_range(-48, 48), "Instances", obj_dayling)
    }
}