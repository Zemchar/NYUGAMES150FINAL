/// @description Insert description here
// You can write your code in this editor
if(room == rBuild){
	draw_set_alpha(1)
	return;
}
if(room == rExplore){
	draw_set_alpha(1)
	global.tank.drawSonar()
	for(var _i = room_height; _i > 0; _i-=100){
		draw_set_color(c_gray)
		draw_text_transformed(0, _i, $"{(room_height - _i)/10}m", 0.2, 0.2, 0);
	}
	draw_set_color(c_lime)
	draw_line_width(mouse_x-30, mouse_y, mouse_x-6, mouse_y, 2)
	draw_line_width(mouse_x+30, mouse_y, mouse_x+6, mouse_y, 2)
	draw_line_width(mouse_x, mouse_y-30, mouse_x, mouse_y-6, 2)
	draw_line_width(mouse_x, mouse_y+30, mouse_x, mouse_y+6, 2)
	draw_circle(mouse_x, mouse_y, 18, true)
}












