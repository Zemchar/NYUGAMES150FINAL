/// @description Insert description here
// You can write your code in this editor
if(actionTimer < actionSpeedBetween){
	return actionTimer++;
}else{
	actionTimer = 0;
	switch(state){
		case eDealerStates.Dealing:
			//TODO: Pause between card dealing
			var _playerNum = ds_list_size(playerHand)
			if(_playerNum<6 && !ds_list_empty(deck)) {
				audio_play_sound(Click_Electronic_00, 0, false)
				var _dealtCard = deck[|ds_list_size(deck) - 1]
				ds_list_delete(deck, ds_list_size(deck) - 1 )
				ds_list_add(playerHand, _dealtCard)
				var spaceNeeded = 0;
				while(place_meeting(room_width/4+spaceNeeded*handSpaceBetween,room_height*0.88,oCard)){
					spaceNeeded++;
				}
				_dealtCard.xTarg = room_width/4+spaceNeeded*handSpaceBetween
				_dealtCard.yTarg = room_height *0.88;
				_dealtCard.inPlayerHand = true;
				break;
			}
			
			state = eDealerStates.Waiting;
			break;
		case eDealerStates.Waiting:
			for(var _i = 0; _i<ds_list_size(playerHand); _i++){
				if(!playerHand[| _i].faceUp){
					playerHand[| _i].faceUp = true;
				}
			}
			break;
		case eDealerStates.Discarding:
			var _disPlayerNum = numCards
			playerChosenCard = undefined;
			opponentChosenCard = undefined;
			actionTimer = 10
			ds_grid_clear(global.tank.config, new Component(0, global.tank.instance))
			for(var _r = 0; _r < ds_grid_height(placementGrid); _r++){
				for(var _c = 0; _c < ds_grid_width(placementGrid); _c++){

					 if(place_meeting(placementGrid[# _c, _r].x, placementGrid[# _c, _r].y, oCard)){
						 global.tank.addComponent(instance_place(placementGrid[# _c, _r].x, placementGrid[# _c, _r].y, oCard).faceIndex, _c, _r)
					 }
					 
				}
			}
			room_goto_next()

		default:
			// pass for right now
			break;
	}
}













