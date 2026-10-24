if (!other.dead and other.can_eat and other.energy < other.max_energy) {
    other.energy = min(other.energy + 5, other.max_energy)
    instance_destroy()
}