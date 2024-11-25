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
			
			break;
			
		
	}
}









