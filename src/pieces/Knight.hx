package src.pieces;

using src.Constraints;
using src.CellInt;

import src.AssetsManager.Color;
import src.Constraints.BoardMove;

class Knight extends Piece {
	override public function new(color:Color, x:Int, y:Int) {
		super(Knight, color, x, y);
	}

	override public function canMoveTo(boardState:Array<Array<Piece>>):Array<BoardMove> {
		var moves:Array<BoardMove> = [];
		for (move in [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]) {
			var tX = move[0] + cellX;
			var tY = move[1] + cellY;

			if (!tX.isOutOfBounds() && !tY.isOutOfBounds()) {
				var lookingAt = boardState[tY][tX];
				if (lookingAt == null) {
					moves.addMove(tX, tY, 0x00FF00);
					continue;
				}
				if (lookingAt.color == color)
					continue;
				moves.addMove(tX, tY, 0xFF0000);
			}
		}

		return moves;
	}
}
