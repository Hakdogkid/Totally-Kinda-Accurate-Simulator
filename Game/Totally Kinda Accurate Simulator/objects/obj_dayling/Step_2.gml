if (dead) exit

if (x > xprevious) {
    facing = 1
}
else if (x < xprevious) {
    facing = -1
}

image_xscale = facing