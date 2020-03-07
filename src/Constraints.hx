package src;

typedef BoardMove = {
	var x:Int;
	var y:Int;
	var color: Int;
};

class Constraints {
    static public final BOARD_SIZE = 8;
	static public final CELL_WIDTH = 64;
	static public final CELL_HEIGHT = 64;
	static public function filterOut(moves:Array<BoardMove>) {
		return moves.filter(move -> {
			return (move.x >= 0 && move.x < BOARD_SIZE && move.y >= 0 && move.y < BOARD_SIZE);
		});
	}
}
