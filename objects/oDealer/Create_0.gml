/// @description Insert description here
// You can write your code in this editor
handSpaceBetween = 90;
numCards = 1;
state = eDealerStates.Dealing
actionSpeedBetween = 20;
actionTimer = actionSpeedBetween;
deck = ds_list_create();
discardPile = ds_list_create();
playerHand = ds_list_create();
opponentHand = ds_list_create();
opponentChosenCard = undefined;
playerChosenCard = undefined;
global.debug = false
cardsReady = 0;
readyForShuffle = false;
placementGrid = ds_grid_create(5,3)
var _newCard;
for(var _i = 0; _i<4; _i++){

	_newCard = instance_create_layer(x, y, "Cards", oCard)
	ds_list_add(deck, _newCard)
	_newCard.faceIndex = 2; // wheel
	_newCard.faceUp = false;
	_newCard.inPlayerHand = false;
	numCards++
}
for(var _i = 0; _i<3; _i++){
	
	_newCard = instance_create_layer(x, y, "Cards", oCard)
	ds_list_add(deck, _newCard)
	_newCard.faceIndex = 3; // wheel
	_newCard.faceUp = false;
	numCards++
	_newCard.inPlayerHand = false;
}
for(var _i = 0; _i<2; _i++){

	_newCard = instance_create_layer(x, y, "Cards", oCard)
		ds_list_add(deck, _newCard)
	_newCard.faceIndex = 4; // wheel
	_newCard.faceUp = false;
	_newCard.inPlayerHand = false;
	numCards++
}
for(var _i = 0; _i<2; _i++){
	
	_newCard = instance_create_layer(x, y, "Cards", oCard)
	_newCard.faceIndex = 5; // wheel
	_newCard.faceUp = false;
	_newCard.inPlayerHand = false;
	numCards++
	ds_list_add(deck, _newCard)
}



for(var _r = 0; _r < ds_grid_width(placementGrid); _r++){
	for(var _c = 0; _c < ds_grid_height(placementGrid); _c++){
		placementGrid[#_r, _c] = instance_create_layer(room_width/6+sprite_get_width(spr_outline)*_r+35*_r, room_height/6+sprite_get_height(spr_outline)*_c+30*_c, "Instances", oOutline)
	}
}


randomize();
ds_list_shuffle(deck)
_newCard = instance_create_layer(x, y, "Cards", oCard)
_newCard.faceIndex = 1; // Core
_newCard.faceUp = false;
_newCard.inPlayerHand = false;
ds_list_add(deck, _newCard)
for(var _i = 0; _i<numCards; _i++){
	deck[|_i].y = room_height*0.8 - (3*_i);
	deck[|_i].x = room_width *0.1
	deck[|_i].xTarg = deck[|_i].x;
	deck[|_i].yTarg = deck[|_i].y;
	deck[|_i].depth = numCards-_i
	deck[|_i].nextDepth = numCards-_i
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










