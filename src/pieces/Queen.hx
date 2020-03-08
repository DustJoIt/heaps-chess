package src.pieces;

using src.Constraints;
using src.CellInt;

import src.AssetsManager.Color;
import src.Constraints.BoardMove;

class Queen extends Piece {
	override public function new(color:Color, x:Int, y:Int) {
		super(Queen, color, x, y);
	}

	override public function canMoveTo(boardState:Array<Array<Piece>>):Array<BoardMove> {
		var moves:Array<BoardMove> = [];
		// Просто скопировал код с ладьи и слона
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

		for (direction in [[1, 1], [1, -1], [-1, 1], [-1, -1]]) {
			var dirX = direction[0];
			var dirY = direction[1];

			var tX = cellX + dirX;
			var tY = cellY + dirY;
			while (!tX.isOutOfBounds() && !tY.isOutOfBounds()) {
				var lookingAt = boardState[tY][tX];
				if (lookingAt != null && lookingAt.color == color)
					break;

				if (lookingAt == null) {
					moves.addMove(tX, tY, 0x00FF00);
				} else {
					moves.addMove(tX, tY, 0xFF0000);
					break;
				}

				tX += dirX;
				tY += dirY;
			}
		}

		return moves;
	}
}
