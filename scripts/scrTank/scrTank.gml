global.tank = undefined;
global.blockSize = 20

function Tank(_obj) constructor{
	config = ds_grid_create(5, 3)
	instance = _obj
	ds_grid_add_region(config, 0, 0, 5, 3, new Component(eComponentTypes.EMPTY, instance))
	wheelCount =0;
	activeParts = ds_list_create()
	bounds = [100, 100, -1, -1]
	gas = 100;
	weight = 1;
	ammo = 0;
	xTarg = _obj.x;
	yTarg = _obj.y;
	
	
	function calculateWeight(){
		var _sum = 0;
		for(var _r =0; _r<ds_grid_width(config); _r++){
			for(var _c = 0; _c<ds_grid_height(config); _c++){
				_sum+=config[# _r, _c].weight
				if(config[# _r, _c].weight != 0) {
					bounds = [
					min(bounds[0], _c),
					min(bounds[1], _r), 
					max(bounds[2], _c), 
					max(bounds[3], _r)]
				}
			}
		}
		show_debug_message($"Weight Recalculated: {_sum}\nBounds Recalculated: {bounds}")
		weight = max(1, _sum)
		return _sum;
	}
	
	function drawSonar(){
		for(var _r =0; _r<ds_grid_height(config); _r++){
			for(var _c = 0; _c<ds_grid_width(config); _c++){
				config[# _c, _r].draw(_c, _r)
				config[# _c, _r].doActionOne();
				config[# _c, _r].doActionTwo();
			}
		}

	}
	
	function addComponent(componentType, _c, _r){
		config[# _c, _r] = new Component(componentType, instance); 
	}
	
	function getMoveParams(){
		var moveDirs = [
		keyboard_check_pressed(ord("A"))*(wheelCount/weight), 
		keyboard_check_pressed(ord("W"))*(wheelCount/weight),
		keyboard_check_pressed(ord("S"))*(wheelCount/weight),
		keyboard_check_pressed(ord("D"))*(wheelCount/weight)
		]
		return moveDirs
	}
	
	function getNearestCell(xpos, ypos){
		var closestDistance = 999999
		show_debug_message(closestDistance)
		var closestCell = [3, 1]
		for(var _r =0; _r<ds_grid_height(config); _r++){
			for(var _c = 0; _c<ds_grid_width(config); _c++){
				if(config[# _c, _r].type != eComponentTypes.EMPTY){
					if(point_distance(xpos, ypos, instance.x+_c, instance.y+_r)<closestDistance){
						closestDistance = point_distance(xpos, ypos, (instance.x+_c), (instance.y+_r));
						closestCell =  [instance.x+(_c*global.blockSize*2.2), instance.y+(_r*global.blockSize*2.2)]
					}
				}
			}
		}
		return closestCell;
	}
}

function Component(componentType, _object) constructor {
	type = componentType; 
	instance = _object
	static nonInertComponents = 0;
	core = false;
	weight = 0;
	fuelCost = 0;
	activationKey = ["", ""]
	targeting = noone;
	selected = false;
	actioning = 0;
	disabled = false;
	projectileProgress = 0;
	switch(type){
		case eComponentTypes.CORE:
			core = true;
			weight = 1;
			break;
		case eComponentTypes.CHAINGUN:
			nonInertComponents++
			fuelCost = 1;
			weight = 3;
			activationKey[0] = $"{nonInertComponents}";
			activationKey[1] = "R"
			break;
		case eComponentTypes.ARMOR:
			weight = 2;
			break;
		case eComponentTypes.MORTAR:
			nonInertComponents++
			activationKey[0] = $"{nonInertComponents}";
			activationKey[1] = "T"
			weight = 5;
			fuelCost = 2;
			break;
		case eComponentTypes.WHEEL:
			fuelCost = 1;
			weight = 1;
			global.tank.wheelCount++;
			break;	
	}
	
	function draw(_c, _r){
		_r *= global.blockSize*2.2
		_c *= global.blockSize*2.2
		draw_set_color(c_lime)
		switch(type){
			case eComponentTypes.CORE:
				draw_set_color(c_yellow)
			case eComponentTypes.ARMOR:
				draw_rectangle(instance.x+_c-global.blockSize, instance.y+_r-global.blockSize, instance.x+_c+global.blockSize, instance.y+_r+global.blockSize, false)
				break;
			case eComponentTypes.WHEEL:
				draw_circle(instance.x+_c, instance.y+_r, global.blockSize, false)
				break;
			case eComponentTypes.CHAINGUN:
				draw_set_color(selected? c_red:c_lime)
				draw_rectangle(instance.x+_c-global.blockSize, instance.y+_r-global.blockSize, instance.x+_c+global.blockSize, instance.y+_r+global.blockSize, true)
				draw_triangle(instance.x+_c, instance.y+_r-global.blockSize, instance.x+_c-global.blockSize*0.7, instance.y+_r+global.blockSize*0.7, instance.x+_c+global.blockSize*0.7, instance.y+_r+global.blockSize*0.7,false);
				if(targeting !=noone){
					draw_set_color(c_maroon)
					if(instance_exists(instance)){
						draw_line(instance.x+_c, instance.y+_r, targeting.x, targeting.y)
						draw_circle(targeting.x, targeting.y, 10, true);
					}
				}
				break;
			case eComponentTypes.MORTAR:
				draw_set_color(selected? c_red:c_lime)
				draw_rectangle(instance.x+_c-global.blockSize, instance.y+_r-global.blockSize, instance.x+_c+global.blockSize, instance.y+_r+global.blockSize, true)
				draw_circle(instance.x+_c, instance.y+_r, global.blockSize, true)
				if(targeting !=noone){
					draw_set_color(c_maroon)
					draw_line(instance.x+_c, instance.y+_r, targeting.x, targeting.y)
					draw_circle(targeting.x, targeting.y, 10, true);
				}
				break;
		}

	}
	
	
	function assignTarget(target){
		targeting = target;
		doActionOne();
	}
	
	function doActionOne() {
		if(keyboard_check_pressed(ord(activationKey[0]))){
			selected = true;
			if(targeting = noone || instance_nearest(mouse_x, mouse_y, oEnemy) != targeting){
				targeting = instance_nearest(mouse_x, mouse_y, oEnemy)
				return
			}
		}
		if(keyboard_check_released(ord(activationKey[0]))){
			selected = false;
		}
	}
	function doActionTwo(){
		if(keyboard_check_pressed(ord(activationKey[1])) && targeting!= noone){
				if(type == eComponentTypes.MORTAR){
					var _splashTargets = ds_list_create();
					show_debug_message(collision_circle_list(targeting.x, targeting.y, 15, oEnemy, true, true, _splashTargets, false))
					for(var _i = 0; _i < ds_list_size(_splashTargets); _i++){
						instance_destroy(_splashTargets[|_i])
					}
					targeting = noone;
				}else if(type == eComponentTypes.CHAINGUN){
					instance_destroy(targeting);
					targeting = noone;
				}
				//TODO: Explode Target
		}
	}
	
}

enum eComponentTypes {
	EMPTY,
	CORE,
	WHEEL,
	ARMOR,
	MORTAR,
	CHAINGUN,
}