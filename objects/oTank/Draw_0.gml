/// @description Insert description here
// You can write your code in this editor
if(room == rBuild){
	return;
}
if(room == rExplore){
	global.tank.drawSonar()
	for(var _i = room_height; _i > 0; _i-=100){
		draw_set_color(c_gray)
		draw_text_transformed(0, _i, $"{(room_height - _i)/10}m", 0.2, 0.2, 0);
	}
}












