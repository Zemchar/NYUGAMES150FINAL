/// @description Insert description here
// You can write your code in this editor
if(stolen != undefined){
	global.tank.addComponent(stolen.component, stolen.grdPos.x, stolen.grdPos.y);
}
if(drop != undefined && drop != eComponentTypes.EMPTY){
	var comp = instance_create_layer(x, y, "Instances", oComponent)
	comp.image_index = drop;
	
}
deathExplosion()
with(oTank){
	shakeScreen = 3;
	alarm[0] = 1;
	alarm[1] += 10
}














