// @Description Spawn Enemies
if(room == rExplore){
	var rndNum = irandom_range(1, 10)
	for(var i = 0; i<rndNum; i++){
		instance_create_layer(x+irandom_range(-camera_get_view_width(view_camera[0]), camera_get_view_width(view_camera[0])),
		x+irandom_range(-camera_get_view_height(view_camera[0]), camera_get_view_height(view_camera[0])),
		"Enemies",
		oEnemy)
	}
}
alarm[1] = 120












