/// @description Insert description here
// You can write your code in this editf
fadetime--;
if(fadetime <= -30){
	fadetime = 30;
}else{
	draw_set_alpha(fadetime/30)
	draw_set_color(stolen ? c_purple: c_red)
	
	draw_circle(x, y, 10, false)
}













