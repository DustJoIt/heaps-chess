package src.pieces;

using src.Constraints;
using src.CellInt;

import src.AssetsManager.Color;
import src.Constraints.MoveType;

class Queen extends Piece {
	override public function new(color:Color, x:Int, y:Int) {
		super(Queen, color, x, y);
	}

	override public function canMoveTo(boardState:Board):Array<MoveType> {
		var moves:Array<MoveType> = [];
		// Просто скопировал код с ладьи и слона
		for (isX in [true, false]) {
			for (direction in [-1, 1]) {
				for (i in 1...Constraints.BOARD_SIZE) {
					var tX = cellX + i * direction * (isX ? 1 : 0);
					var tY = cellY + i * direction * (isX ? 0 : 1);

					if (tX.isOutOfBounds() || tY.isOutOfBounds())
						break;

					var lookingAt = boardState.getPiece(tX, tY);
					if (lookingAt == null) {
						moves.push(Move(this.createCell(tX, tY)));
						continue;
					}

					if (lookingAt.color == color)
						break;

					moves.push(Capture(this.createCell(tX, tY)));
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
				var lookingAt = boardState.getPiece(tX, tY);
				if (lookingAt != null && lookingAt.color == color)
					break;

				if (lookingAt == null) {
					moves.push(Move(this.createCell(tX, tY)));
				} else {
					moves.push(Capture(this.createCell(tX, tY)));
					break;
				}

				tX += dirX;
				tY += dirY;
			}
		}


		return moves;
	}
}
