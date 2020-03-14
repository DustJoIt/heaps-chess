package src;

import src.pieces.King;
import src.Constraints.MoveType;
import src.Constraints.Cell;
import src.AssetsManager.Color;
import src.pieces.Piece;

typedef HMove = {
	piece:Piece,
	move:MoveType,
	from:Cell
}

class Board {
	private var drawer:Drawer;

	public var pieces:Array<Array<Piece>>;

	private var history:Array<HMove> = [];
	private var beatenWhite:Array<Array<Bool>>;
	private var beatenBlack:Array<Array<Bool>>;

	private var kingBlack:King;
	private var kingWhite:King;

	public function new(drawer:Drawer) {
		this.drawer = drawer;
		pieces = [
			for (j in 0...Constraints.BOARD_SIZE) [for (i in 0...Constraints.BOARD_SIZE) null]
		];
	}

	private function getBeatenCells(pieces:Array<Array<Piece>>, color:Color):Array<Array<Bool>> {
		var map2 = pieces.map(row -> row.map(cell -> (return (cell != null) && (cell.color != color))));

		for (row in pieces) {
			for (cell in row) {
				if (cell == null)
					continue;
				if (cell.color == color)
					continue;

				var canGoTo = cell.getBeaten(this);

				for (move in canGoTo) {
					// TODO - ленивый костыль
					var move_cell:Cell = move.getParameters()[0];
					map2[move_cell.y][move_cell.x] = true;
				}
			}
		}

		return map2;
	}

	public function getPiece(x:Int, y:Int) {
		return pieces[y][x];
	}

	public function logMove(move:HMove) {
		history.push(move);
	}

	public function lastMove() {
		return history[history.length - 1];
	}

	public function addPiece(piece:Piece, x:Int, y:Int) {
		drawer.addPiece(piece);
		var currAt = pieces[y][x];
		if (currAt != null) {
			currAt.remove();
		}

		if (Std.is(piece, King)) {
			if (piece.color == White) {
				kingWhite = cast(piece, King);
			} else {
				kingBlack = cast(piece, King);
			}
		}

		pieces[y][x] = piece;
	}

	public function getKing(color:Color) {
		return color == White ? kingWhite : kingBlack;
	}

	public function isCheck(color:Color) {
		var king = getKing(color);
		var map = getBeatenMap(color);
		return map[king.cellY][king.cellX];
	}

	public function willMoveCheck(piece:Piece, x:Int, y:Int) {
		var lookAt = pieces[y][x];
		var origX = piece.cellX;
		var origY = piece.cellY;

		pieces[y][x] = piece;
		pieces[piece.cellY][piece.cellX] = null;
		piece.cellX = x;
		piece.cellY = y;

		var king = getKing(piece.color);
		var newMap = this.getBeatenCells(pieces, piece.color);
		var answ = newMap[king.cellY][king.cellX];

		piece.cellX = origX;
		piece.cellY = origY;
		pieces[y][x] = lookAt;
		pieces[origY][origX] = piece;

		return answ;
	}

	public function filterCheckMoves(piece:Piece, moves:Array<MoveType>) {
		return moves.filter(move -> {
			// TODO - вынести?
			var to:Cell = move.getParameters()[0];
			return !willMoveCheck(piece, to.x, to.y);
		});
	}

	public function movePiece(piece:Piece, x:Int, y:Int) {
		var goesTo = pieces[y][x];
		if (goesTo != null) {
			goesTo.remove();
		}

		pieces[y][x] = piece;
		pieces[piece.cellY][piece.cellX] = null;
		piece.moveTo(x, y);
	}

	public function updateBeatenMaps() {
		beatenWhite = this.getBeatenCells(pieces, White);
		beatenBlack = this.getBeatenCells(pieces, Black);
	}

	public function getBeatenMap(color:Color) {
		return color == Black ? beatenBlack : beatenWhite;
	}

	public function removePiece(piece:Piece) {
		pieces[piece.cellY][piece.cellX] = null;
		piece.remove();
	}
}
