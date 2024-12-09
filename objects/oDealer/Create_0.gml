/// @description Insert description here
// You can write your code in this editor
handSpaceBetween = 90;
state = eDealerStates.Dealing
actionSpeedBetween = 20;
actionTimer = actionSpeedBetween;
discardPile = ds_list_create();
playerHand = ds_list_create();
opponentHand = ds_list_create();
opponentChosenCard = undefined;
playerChosenCard = undefined;
global.debug = false
cardsReady = 0;
readyForShuffle = false;
placementGrid = ds_grid_create(5,3)

if(ds_list_size(global.playerCards) == 0 ){
	new Card(1)
	new Card(2)
	new Card(5);

}


for(var _r = 0; _r < ds_grid_width(placementGrid); _r++){
	for(var _c = 0; _c < ds_grid_height(placementGrid); _c++){
		placementGrid[#_r, _c] = instance_create_layer(room_width/6+sprite_get_width(spr_outline)*_r+35*_r, room_height/6+sprite_get_height(spr_outline)*_c+30*_c, "Instances", oOutline)
		if(place_meeting(room_width/6+sprite_get_width(spr_outline)*_r+35*_r,room_height/6+sprite_get_height(spr_outline)*_c+30*_c, oCard) && global.tank.config[# _r, _c].type == eComponentTypes.EMPTY){
			ds_list_delete(global.playerCards, ds_list_find_index(global.playerCards, instance_nearest(room_width/6+sprite_get_width(spr_outline)*_r+35*_r, room_height/6+sprite_get_height(spr_outline)*_c+30*_c, oCard)));
			instance_destroy(instance_nearest(room_width/6+sprite_get_width(spr_outline)*_r+35*_r,room_height/6+sprite_get_height(spr_outline)*_c+30*_c, oCard))
		}else if(place_meeting(room_width/6+sprite_get_width(spr_outline)*_r+35*_r,room_height/6+sprite_get_height(spr_outline)*_c+30*_c, oCard)){
			new Card(instance_place(room_width/6+sprite_get_width(spr_outline)*_r+35*_r,room_height/6+sprite_get_height(spr_outline)*_c+30*_c, oCard).faceIndex);
		}
	}
}


randomize();
ds_list_shuffle(global.playerCards)
var floatToTop = -1;
for(var _i = 0; _i<ds_list_size(global.playerCards); _i++){
	show_debug_message(_i);
	if(global.playerCards[|_i].faceIndex == 1){
		floatToTop = _i
		instance_destroy(global.playerCards[|_i])
		ds_list_delete(global.playerCards, _i)
		new Card(1) // recreate core card
		continue;
		
	}
	global.playerCards[|_i].y = room_height*0.8 - (3*_i);
	global.playerCards[|_i].x = room_width *0.1
	global.playerCards[|_i].xTarg = global.playerCards[|_i].x;
	global.playerCards[|_i].yTarg = global.playerCards[|_i].y;
	global.playerCards[|_i].depth = ds_list_size(global.playerCards)-_i
	global.playerCards[|_i].nextDepth = ds_list_size(global.playerCards)-_i
}






enum eDealerStates{
	Default,
	Dealing,
	Shuffling,
	Discarding,
	Comparing,
	Playing,
	Waiting,
	Recycling
}










