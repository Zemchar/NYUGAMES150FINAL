/// @description Insert description here
// You can write your code in this editf
fadetime--;
if(fadetime <= -30){
	fadetime = 30;
}else{
	draw_set_alpha(fadetime/30)
	draw_circle_color(x, y, 8, c_red, c_red, false)
}













