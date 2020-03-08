package src;

using src.CellInt;

import src.AssetsManager.PieceType;
import src.AssetsManager.Kind;

typedef BoardMove = {
	var x:Int;
	var y:Int;
	var color:Int;
};

class Constraints {
	static public final BOARD_SIZE = 8;
	static public final CELL_WIDTH = 64;
	static public final CELL_HEIGHT = 64;

	static public final gameStart: Array<Array<Kind>> = [
		[
			Kind.Piece(Rook, Black),
			Kind.Piece(Knight, Black),
			Kind.Piece(Bishop, Black),
			Kind.Piece(Queen, Black),
			Kind.Piece(King, Black),
			Kind.Piece(Bishop, Black),
			Kind.Piece(Knight, Black),
			Kind.Piece(Rook, Black)
		],
		[for (_ in 0...BOARD_SIZE) Kind.Piece(Pawn, Black)],
		[],
		[],
		[],
		[],
		[for (_ in 0...BOARD_SIZE) Kind.Piece(Pawn, White)],
		[
			Kind.Piece(Rook, White),
			Kind.Piece(Knight, White),
			Kind.Piece(Bishop, White),
			Kind.Piece(Queen, White),
			Kind.Piece(King, White),
			Kind.Piece(Bishop, White),
			Kind.Piece(Knight, White),
			Kind.Piece(Rook, White)
		]

	];

	static public inline function addMove(moves:Array<BoardMove>, x:Int, y:Int, color:Int) {
		moves.push({
			x: x,
			y: y,
			color: color
		});
	}

	static public function filterOut(moves:Array<BoardMove>) {
		return moves.filter(move -> {
			return (!move.x.isOutOfBounds() && !move.y.isOutOfBounds());
		});
	}
}
