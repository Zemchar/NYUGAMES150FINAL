enum HANDS{
	player,
	opponent,
	discard,
	main
}

function position(xpos, ypos) constructor{
	x = xpos;
	y = ypos;
	function checkDefined(){
		return (x >= 0 && y >= 0);
	}
}

function Card(cardFaceIndex) constructor{
	fIndex = cardFaceIndex;
	var _newCard;
	_newCard = instance_create_layer(0,0, "Cards", oCard)
	_newCard.faceIndex = cardFaceIndex; // wheel
	_newCard.faceUp = false;
	_newCard.inPlayerHand = false;
	ds_list_add(global.playerCards, _newCard)
}