/// @description Insert description here
// You can write your code in this editor
health = 3
fadetime = 30;
targeted = false;
drop = eComponentTypes.EMPTY;
state = eEnemyState.Attacking
windUp = 100
part_system_depth(global.partSys, 30); 
death = part_type_create();
part_type_shape(death, pt_shape_square)
part_type_color2(death, c_yellow, c_orange)
part_type_size(death, 0.1, 0.2, 0, 0);
part_type_speed(death, 1, 3, -0.05, 0);
// Min/Max are in angles
part_type_direction(death, 0, 360, 0, 0);
// The life is in frames/steps
part_type_life(death, 20, 40);

object_set_mask(oEnemy, sprCollisionEnemy)
if(irandom(100) < 20){
	drop = choose(eComponentTypes.ARMOR, 
	eComponentTypes.CHAINGUN, 
	eComponentTypes.MORTAR, 
	eComponentTypes.WHEEL)
}

enum eEnemyState{
	Attacking,
	Grabbing,
	Running,
	Dead
}



function Stolen(pos = new position(-1, -1), comp= eComponentTypes.EMPTY) constructor {
	grdPos = pos
	component = comp

}
targetCelPos = new position(-1, -1)
stolen = undefined;
retreatTarget = choose(
				 new position(0, 0),
				 new position(room_width, 0),
				 new position(0, room_height),
				 new position(room_width, room_height))
	
function deathExplosion(){
	part_particles_create(global.partSys, x, y, death, 40)
}






