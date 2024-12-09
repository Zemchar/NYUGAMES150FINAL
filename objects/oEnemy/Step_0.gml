/// @description Insert description here
// You can write your code in this editor

if(health >=1){

	switch(state){
		case eEnemyState.Attacking:
			targetCelPos.checkDefined()
			targetCelPos.x = global.tank.getNearestCell(x, y)[0];
			targetCelPos.y = global.tank.getNearestCell(x, y)[1];
			mp_potential_step_object(targetCelPos.x, targetCelPos.y, 1, oEnemy);
			if(distance_to_point(targetCelPos.x, targetCelPos.y) < 20){
				state = eEnemyState.Grabbing;
			}
			break;
		case eEnemyState.Grabbing:
			var nearest = global.tank.getNearestCellId(x,y)
			targetCelPos.checkDefined()
			global.tank.config[# nearest[0], nearest[1]].targeted = true;
			if(distance_to_point(targetCelPos.x, targetCelPos.y) > 30){
				global.tank.config[# nearest[0], nearest[1]].targeted = false;
				state = eEnemyState.Attacking;
				break;
			}
			if(windUp-- <= 0){
				if(global.tank.config[# nearest[0], nearest[1]].type == eComponentTypes.CORE){
					global.tank.gas = 0;
					// kill player
					break;
				}
				stolen = new Stolen(new position(global.tank.getNearestCellId(x, y)[0], global.tank.getNearestCellId(x, y)[1]),global.tank.config[# nearest[0], nearest[1]].type);
				
				global.tank.addComponent( eComponentTypes.EMPTY, nearest[0], nearest[1])
				state = eEnemyState.Running;
				windUp = 120;
				break;
			}
			break;
		case eEnemyState.Running:
			mp_potential_step(retreatTarget.x, retreatTarget.y, 2.5, false);
			var cx = camera_get_view_x(view_camera[0]);
			var cy = camera_get_view_y(view_camera[0]);

			var ch = camera_get_view_height(view_camera[0]);
			var cw = camera_get_view_width(view_camera[0]);

			//destory is outside camera
			if !point_in_rectangle(x, y, cx, cy, cx+cw, cy+ch){
				instance_destroy(id, false);   
			}
			break;
	}
}else{
	instance_destroy()
}









