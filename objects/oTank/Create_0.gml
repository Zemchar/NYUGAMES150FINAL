/// @description Insert description here
// You can write your code in this editor
global.playerCards = ds_list_create()
global.tank ??= new Tank(self) 
movSpeed = 150
global.tank.calculateWeight()
global.partSys = part_system_create();
mortarCooldown = -1;
mortarLandingSpot = new position(-1, -1)
mortarFireTimer = 60;
shakeScreen=10;

function vfxShakeScreen(dur){
	shakeScreen = dur;
}

part_system_depth(global.partSys, 30); 
mortarfire = part_type_create();
part_type_shape(mortarfire, pt_shape_explosion)
part_type_color2(mortarfire, c_yellow, c_orange)
part_type_size(mortarfire, 0.3, 0.5, 0, 0);
part_type_speed(mortarfire, 2, 4, -0.05, 0);
// Min/Max are in angles
part_type_direction(mortarfire, 0, 360, 0, 0);
// The life is in frames/steps
part_type_life(mortarfire, 30, 60);


















