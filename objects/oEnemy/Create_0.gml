/// @description Insert description here
// You can write your code in this editor
health = 3
fadetime = 30;
drop = eComponentTypes.EMPTY;
state = eEnemyState.Attacking
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











