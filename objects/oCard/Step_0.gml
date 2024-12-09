/// @description Insert description here
// You can write your code in this editor
// Check for mouse over
if(frozen || room != rBuild) return
if(inPlayerHand && faceIndex == 1){
	inPlayerHand = false;
	xTarg = room_width/6+sprite_get_width(spr_outline)*2+64*2
	yTarg = room_height/6+sprite_get_height(spr_outline)+64
	instance_nearest(room_width/6+sprite_get_width(spr_outline)*2+64*2, room_height/6+sprite_get_height(spr_outline)+64, oOutline).visible = false
}
if(inPlayerHand && 
oDealer.state == eDealerStates.Waiting &&
(held || point_in_rectangle(mouse_x, mouse_y, x-sprite_get_width(sprite_index)/2,  y-sprite_get_height(sprite_index)/2,  x+sprite_get_width(sprite_index)/2, y+sprite_get_height(sprite_index)/2)))
{
	if(mouse_check_button(mb_left) && oDealer.state == eDealerStates.Waiting && 
	(oDealer.playerChosenCard == self || oDealer.playerChosenCard == undefined)){
		y = mouse_y
		x = mouse_x
		depth = 0;
		oDealer.playerChosenCard = self;
		held = true;
		exit;
	}
	if(!moving && !inSlot){
		yTarg = room_height*0.88
	}
}
if(oDealer.playerChosenCard == self && inPlayerHand == true && !mouse_check_button(mb_left)){
	
	if(place_meeting(x, y, oOutline) && !place_meeting(x, y, oCard)){
		inSlot = true;
		xTarg = instance_nearest(x, y, oOutline).x
		yTarg = instance_nearest(x, y, oOutline).y
		oDealer.state = eDealerStates.Dealing
		audio_play_sound(choose(Click_Mechanical_00, Click_Mechanical_01), 0, false)
		show_debug_message(ds_list_find_index(oDealer.playerHand, id))
		ds_list_delete(oDealer.playerHand, ds_list_find_index(oDealer.playerHand, id))
	}if(place_meeting(x, y, oDeleteCard) && !place_meeting(x, y, oCard)){
		oDealer.state = eDealerStates.Dealing;
		ds_list_delete(oDealer.playerHand, ds_list_find_index(oDealer.playerHand, id))
		ds_list_delete(global.playerCards, ds_list_find_index(global.playerCards, id))
		instance_destroy()
	}
	held = false;
	oDealer.playerChosenCard = undefined;
	moving = false;
}

if(point_distance(x, y, xTarg, yTarg) < 1){
	x = xTarg
	y=yTarg

	moving = false;
	if(depth != nextDepth){
		depth = nextDepth
		nextDepth = depth
	}

	return
}
moving = true;
x += (xTarg-x) * 0.15
y += (yTarg-y) * 0.15



	












