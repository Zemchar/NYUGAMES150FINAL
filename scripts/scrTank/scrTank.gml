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
			activationKey[1] = "r"
			break;
		case eComponentTypes.ARMOR:
			weight = 2;
			break;
		case eComponentTypes.MORTAR:
			nonInertComponents++
			activationKey[0] = $"{nonInertComponents}";
			activationKey[1] = "t"
			weight = 5;
			fuelCost = 2;
			break;
		case eComponentTypes.WHEEL:
			fuelCost = 1;
			weight = 3;
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
				break;
			case eComponentTypes.MORTAR:
				draw_set_color(selected? c_red:c_lime)
				draw_rectangle(instance.x+_c-global.blockSize, instance.y+_r-global.blockSize, instance.x+_c+global.blockSize, instance.y+_r+global.blockSize, true)
				draw_circle(instance.x+_c, instance.y+_r, global.blockSize, true)
				break;
		}
		if(targeting !=noone){
			draw_set_color(c_maroon)
			draw_line(instance.x+_c, instance.y+_r, targeting.x, targeting.y)
			draw_circle(targeting.x, targeting.y, 1.5, true);
		}
	}
	
	
	function assignTarget(target){
		targeting = target;
		doActionOne();
	}
	
	function doActionOne() {
		if(keyboard_check_pressed(ord(activationKey[0]))){
			
				selected = !selected;
				if(targeting = noone){
					targeting = instance_nearest(mouse_x, mouse_y, oEnemy)
					return;
				}
			else{
					actioning= 60;

					if(type == eComponentTypes.MORTAR){
						var _splashTargets = ds_list_create();
						collision_rectangle_list(targeting.x-5, targeting.y-5, targeting.x+5, targeting.y+5, all, false, true, _splashTargets, true)
						for(var _i = 0; _i < ds_list_size(_splashTargets); _i++){
							instance_destroy(_splashTargets[|_i])
						}
					}else if(type == eComponentTypes.CHAINGUN){
						instance_destroy(targeting);
					}
					//TODO: Explode Target
				}
				global.tank.useFuel(fuelCost);
	
			}
	}
	function doActionTwo(){
		if(keyboard_check_pressed(ord(activationKey[1]))){
			return 0;
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