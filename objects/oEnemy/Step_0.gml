/// @description Insert description here
// You can write your code in this editor
if(health > 0){

	switch(state){
		case eEnemyState.Attacking:
			targetCelPos.checkDefined()
			targetCelPos.x = global.tank.getNearestCell(x, y)[0];
			targetCelPos.y = global.tank.getNearestCell(x, y)[1];
			show_debug_message(targetCelPos.x)
			mp_potential_step_object(targetCelPos.x, targetCelPos.y, 1, oEnemy);
			if(distance_to_point(targetCelPos.x, targetCelPos.y) < 20){
				state = eEnemyState.Grabbing;
			}
			break;
		case eEnemyState.Grabbing:
			var nearest = global.tank.getNearestCellId(x,y)
			targetCelPos.checkDefined()
			if(distance_to_point(targetCelPos.x, targetCelPos.y) > 30){
				state = eEnemyState.Attacking;
			}
			if(windUp-- <= 0){
				if(global.tank.config[# nearest[0], nearest[1]].type == eComponentTypes.CORE){
					global.tank.gas = 0;
					// kill player
					break;
				}
				stolen = new Stolen(new position(global.tank.getNearestCell(x, y)[0], global.tank.getNearestCell(x, y)[1]),global.tank.config[# nearest[0], nearest[1]].type);
				global.tank.addComponent( eComponentTypes.EMPTY, nearest[0], nearest[1])
				state = eEnemyState.Running;
				windUp = 100;
				break;
			}
			break;
			
		
	}
}









