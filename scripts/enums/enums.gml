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