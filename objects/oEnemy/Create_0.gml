/// @description Insert description here
// You can write your code in this editor
health = 3
fadetime = 30;
drop = eComponentTypes.EMPTY;
state = eEnemyState.Attacking

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

function position(xpos, ypos) constructor{
	x = xpos;
	y = ypos;
	function checkDefined(){
		return (x >= 0 && y >= 0);
	}
}
targetCelPos = new position(-1, -1)








