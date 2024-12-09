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
		calculateWeight();
	}
	
	function getMoveParams(){
		var moveDirs = [
		keyboard_check(ord("A"))*(wheelCount/weight)*0.1, 
		keyboard_check(ord("W"))*(wheelCount/weight)*0.1,
		keyboard_check(ord("S"))*(wheelCount/weight)*0.1,
		keyboard_check(ord("D"))*(wheelCount/weight)*0.1
		]
		return moveDirs
	}
	
	function getNearestCell(xpos, ypos){
		var closestDistance = 999999

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
	function getNearestCellId(xpos, ypos){
		var closestDistance = 999999
		var closestCell = [3, 1]
		for(var _r =0; _r<ds_grid_height(config); _r++){
			for(var _c = 0; _c<ds_grid_width(config); _c++){
				if(config[# _c, _r].type != eComponentTypes.EMPTY){
					if(point_distance(xpos, ypos, instance.x+_c, instance.y+_r)<closestDistance){
						closestDistance = point_distance(xpos, ypos, (instance.x+_c), (instance.y+_r));
						closestCell =  [_c, _r]
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
	static targetedEnemies = ds_list_create()
	core = false;
	weight = 0;
	fuelCost = 0;
	activationKey = ["", ""]
	targeting = -4;
	selected = false;
	actioning = 0;
	disabled = false;
	projectileProgress = 0;
	targeted = false;
	switch(type){
		case eComponentTypes.CORE:
			core = true;
			weight = 1;
			break;
		case eComponentTypes.CHAINGUN:
			fuelCost = 1;
			weight = 3;
			activationKey[0] = $"Q";
			activationKey[1] = "E"
			break;
		case eComponentTypes.ARMOR:
			weight = 2;
			break;
		case eComponentTypes.MORTAR:
			nonInertComponents++
			activationKey[0] = $"{nonInertComponents}";
			activationKey[1] = $"R"
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
		draw_set_color(targeted? c_orange: c_lime)
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
				if(selected) draw_set_color(c_red)
				draw_rectangle(instance.x+_c-global.blockSize, instance.y+_r-global.blockSize, instance.x+_c+global.blockSize, instance.y+_r+global.blockSize, true)
				draw_triangle(instance.x+_c, instance.y+_r-global.blockSize, instance.x+_c-global.blockSize*0.7, instance.y+_r+global.blockSize*0.7, instance.x+_c+global.blockSize*0.7, instance.y+_r+global.blockSize*0.7,false);
				if(instance_exists(targeting)){
					draw_set_color(c_maroon)
					if(instance_exists(instance)){
						draw_line(instance.x+_c, instance.y+_r, targeting.x, targeting.y)
						draw_circle(targeting.x, targeting.y, 10, true);
					}
				}
				break;
			case eComponentTypes.MORTAR:
				if(selected) draw_set_color(c_red)
				draw_rectangle(instance.x+_c-global.blockSize, instance.y+_r-global.blockSize, instance.x+_c+global.blockSize, instance.y+_r+global.blockSize, true)
				draw_circle(instance.x+_c, instance.y+_r, global.blockSize, true)
				if(instance_exists(targeting)){
					draw_set_color(c_maroon)
					draw_line(instance.x+_c, instance.y+_r, targeting.x, targeting.y)
					draw_circle(targeting.x, targeting.y, 80, true);
				}
				break;
		}

	}
	
	
function doActionOne() {
    if (keyboard_check_pressed(ord(activationKey[0])) && type == eComponentTypes.CHAINGUN) {
        selected = true;

        // Find the nearest enemy that's not already the current target

        var nearestEnemy = instance_nearest(mouse_x, mouse_y, oEnemy);
		var minDistance = distanceToMouse(nearestEnemy)+300;
        for (var i = 0; i < instance_number(oEnemy); i++) {
            var enemy = instance_find(oEnemy, i);
			if(!instance_exists(enemy)){continue;}
            var dist = distanceToMouse(enemy)
            if (dist < minDistance && enemy != targeting && enemy.targeted = false) {
                minDistance = dist;
                nearestEnemy = enemy;
				enemy.targeted = true;
				continue;
            }
			enemy.targeted = false;
        }

        // Update the target if a new nearest enemy is found
        if (nearestEnemy != noone && distanceToMouse(nearestEnemy) < 1000) {
            targeting = nearestEnemy;
            ds_list_add(targetedEnemies, nearestEnemy);
        }
    }else if (type == eComponentTypes.MORTAR && keyboard_check_pressed(ord(activationKey[0]))){
		targeting = new position(mouse_x, mouse_y)
	}
    else if (keyboard_check_released(ord(activationKey[0]))) {
        selected = false;
    }
}
	
	function distanceToMouse(objectInstance){
		var _x = abs(objectInstance.x-mouse_x);
		var _y = abs(objectInstance.y-mouse_y);
		return(sqrt(sqr(_x) + sqr(_y)))
	}
	function doActionTwo(){
		if(keyboard_check_pressed(ord(activationKey[1])) && targeting!= noone){
				if(type == eComponentTypes.MORTAR){
					if(!oTank.mortarLandingSpot.checkDefined()){
						oTank.mortarFireTimer = 120
						oTank.mortarLandingSpot = new position(targeting.x, targeting.y)
						oTank.mortarCooldown = self;
					}
				}else if(type == eComponentTypes.CHAINGUN){
					instance_destroy(targeting)
					targeting = noone;
				}
		}
		if(oTank.mortarFireTimer > 0 && oTank.mortarLandingSpot.checkDefined() && type ==eComponentTypes.MORTAR){
			oTank.mortarFireTimer--;
		}if(oTank.mortarFireTimer == 0 && type == eComponentTypes.MORTAR && oTank.mortarCooldown == self){
			var _splashTargets = ds_list_create();
			part_particles_create(global.partSys, oTank.mortarLandingSpot.x, oTank.mortarLandingSpot.y, oTank.mortarfire, 80)
			oTank.shakeScreen = 13;
			oTank.alarm[0] = 1;
			show_debug_message(collision_circle_list(oTank.mortarLandingSpot.x, oTank.mortarLandingSpot.y, 80, oEnemy, true, true, _splashTargets, false))
			for(var _i = 0; _i < ds_list_size(_splashTargets); _i++){
					
				instance_destroy(_splashTargets[|_i])
			}
			targeting = noone;
			oTank.mortarFireTimer = 160;
			oTank.mortarLandingSpot = new position(-1, -1)
			oTank.mortarCooldown = undefined
		}else if(oTank.mortarFireTimer == 160 && type == eComponentTypes.MORTAR && instance_exists(targeting)){
			oTank.mortarCooldown = self
			oTank.mortarLandingSpot = new position(targeting.x, targeting.y)
		}else if(oTank.mortarFireTimer == 160 && type == eComponentTypes.MORTAR){
			oTank.mortarFireTimer = -1;
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