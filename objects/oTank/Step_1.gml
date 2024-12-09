/// @description Insert description here
// You can write your code in this editor
var _movement = global.tank.getMoveParams()
if(room == rBuild){
	return;
}



if(ceil(global.tank.gas) > 0){
	var _cX = (_movement[3] - _movement[0])*movSpeed;
	var _cY = (_movement[2] - _movement[1])*movSpeed;
	
	if(x+_cX+(global.tank.bounds[2]*global.blockSize*2)> room_width || (x+_cX+(global.tank.bounds[0]*global.blockSize*2)<=0)||
	y+_cY+(global.tank.bounds[3]*global.blockSize*2)>room_height || y+_cY+(global.tank.bounds[1]*global.blockSize*2)<=0){
		return;
	}
	if(collision_rectangle(x+_cX+global.tank.bounds[0], y+_cY+global.tank.bounds[1], x+_cX+global.tank.bounds[2], y+_cY+global.tank.bounds[3], all, true, true)==noone){
		if(_cY != 0 || _cX != 0){
			global.tank.gas-=abs(_cY)*0.001;
			global.tank.gas-=abs(_cX)*0.001;
			x+=_cX;
			y+=_cY;
			if(random(100) < 20){
				audio_stop_sound(Slide_Electronic_02)
				audio_play_sound(Slide_Electronic_02, 0, false)
			}

		}
	}
}else{
	room_goto(rBuild)
}















