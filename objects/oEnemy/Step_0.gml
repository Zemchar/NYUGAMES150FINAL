/// @description Insert description here
// You can write your code in this editor
if(health > 0){

	switch(state){
		case eEnemyState.Attacking:
			if(!targetCelPos.checkDefined()){
				global.tank.getNearestCell(x, y);
			}
			mp_potential_step_object(targetCelPos.x, targetCelPos.y, 1, oEnemy);
			
		
	}
}









