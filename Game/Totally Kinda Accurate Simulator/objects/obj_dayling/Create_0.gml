/*
Daylings

TRAITS:

Primal - Your civilization/entities attack your enemies by melee attacks. (Attack damage = 5, attacks once per second)
Lifesteal - When killing an enemy, gain 5 hp
Tanky -Your civilization/entities have a base 20 hp each

*/

//Base Stats ng Daylings
event_inherited()
hp = 20
max_hp = 20
atk = 5

//grrr
enemy_obj = Pinkits
attack_range = 33
attacking = false
attack_cd = 0
attack_hitbox = noone
facing = 1

//state management akin to script
sight_range = 300
hungry_energy = 8
state = DayState.FORAGE
recover_energy = 14