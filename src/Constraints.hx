package src;

using src.CellInt;

import src.AssetsManager.PieceType;
import src.AssetsManager.Kind;
import src.pieces.Piece;

typedef Cell = {
	x:Int,
	y:Int
}

enum MoveType {
	Move(to:Cell);
	Capture(to:Cell);
	Castling(to:Cell, rook:Piece);
	CastlingLong(to:Cell, rook:Piece);
	EnPassant(to:Cell, pawn:Piece);
}

class Constraints {
	static public final BOARD_SIZE = 8;
	static public final CELL_WIDTH = 64;
	static public final CELL_HEIGHT = 64;

	static public final gameStart:Array<Array<Kind>> = [
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

	static public inline function getPos(piece:Piece):Cell {
		return {
			x: piece.cellX,
			y: piece.cellY
		}
	}

	static public inline function createCell(piece:Piece, x:Int, y:Int):Cell {
		return {
			x: x,
			y: y
		}
	}

	// static public function filterOut(moves:Array<MoveType>) {
	// 	return moves.filter(move -> {
	// 		return (!move.x.isOutOfBounds() && !move.y.isOutOfBounds());
	// 	});
	// }
}
