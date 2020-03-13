package src;

import src.Constraints.Cell;
import src.AssetsManager.Color;
import src.pieces.Piece;

class Board {
	private var drawer:Drawer;

	public var pieces:Array<Array<Piece>>;

	private var beatenWhite:Array<Array<Bool>>;
	private var beatenBlack:Array<Array<Bool>>;

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

	public function addPiece(piece:Piece, x:Int, y:Int) {
		drawer.addPiece(piece);
		var currAt = pieces[y][x];
		if (currAt != null) {
			currAt.remove();
		}

		pieces[y][x] = piece;
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
