package src;

import src.AssetsManager.Color;

typedef BoardMove = {
	var x:Int;
	var y:Int;
	var pieceColor:Color;
	var canAttack:Bool;
	var canOnlyAttack:Bool;
};

class Constraints {
    static public final BOARD_SIZE = 8;
    
	static public function filterOut(moves:Array<BoardMove>) {
		return moves.filter(move -> {
			return (move.x >= 0 && move.x < BOARD_SIZE && move.y >= 0 && move.y < BOARD_SIZE);
		});
	}
}