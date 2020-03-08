package src.pieces;

import src.AssetsManager.Color;
import src.Constraints.BoardMove;

using src.CellInt;
using src.Constraints;

class Rook extends Piece {
	override public function new(color:Color, x:Int, y:Int) {
		super(Rook, color, x, y);
	}

	override public function canMoveTo(boardState:Array<Array<Piece>>):Array<BoardMove> {
		var moves:Array<BoardMove> = [];

		for (isX in [true, false]) {
			for (direction in [-1, 1]) {
				for (i in 1...Constraints.BOARD_SIZE) {
					var tX = cellX + i * direction * (isX ? 1 : 0);
					var tY = cellY + i * direction * (isX ? 0 : 1);
					
					if (tX.isOutOfBounds() || tY.isOutOfBounds())
						break;

					var lookingAt = boardState[tY][tX];
					if (lookingAt == null) {
						moves.addMove(tX, tY, 0x00FF00);
						continue;
					}

					if (lookingAt.color == color)
						break;

					moves.addMove(tX, tY, 0xFF0000);
					break;
				}
			}
		}

		return moves;
	}
}
