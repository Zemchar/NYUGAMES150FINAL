/// @description Insert description here
// You can write your code in this editor
shakeScreen--;
var _camX = camera_get_view_x(view_camera[0])
var _camY = camera_get_view_y(view_camera[0])
// Sets position of camera randomly in x/y
camera_set_view_pos(view_camera[0],
_camX+irandom_range(-shakeScreen, shakeScreen) * 1.5,
_camY+irandom_range(-shakeScreen, shakeScreen) * 1.5);

if(shakeScreen <= 0){
	shakeScreen = 5;
}else{
	// increasingly close together frames
	alarm[0] = shakeScreen;
}














