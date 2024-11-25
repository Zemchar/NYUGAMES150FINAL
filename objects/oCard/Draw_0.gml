if(faceUp) image_index = faceIndex;
else image_index = 0;

draw_sprite(sprite_index, image_index, x, y)
if(global.debug){
	var _debugStr = $"{faceIndex}\nMoving? {moving}\nPH: {inPlayerHand}"
	draw_text_ext_color(x-sprite_get_width(sprite_index)/2, y-string_height_ext(_debugStr, 20, 131)/2, _debugStr, 20, 131, c_black, c_black, c_black, c_black, 1)
}












