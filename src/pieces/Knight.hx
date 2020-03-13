package src.pieces;

using src.Constraints;
using src.CellInt;

import src.AssetsManager.Color;
import src.Constraints.MoveType;

class Knight extends Piece {
	override public function new(color:Color, x:Int, y:Int) {
		super(Knight, color, x, y);
	}

	override public function canMoveTo(boardState:Board):Array<MoveType> {
		var moves:Array<MoveType> = [];
		for (move in [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]) {
			var tX = move[0] + cellX;
			var tY = move[1] + cellY;

			if (!tX.isOutOfBounds() && !tY.isOutOfBounds()) {
				var lookingAt = boardState.getPiece(tX, tY);
				if (lookingAt == null) {
					moves.push(Move(this.createCell(tX, tY)));
					continue;
				}
				if (lookingAt.color == color)
					continue;
				moves.push(Capture(this.createCell(tX, tY)));
			}
		}

		return moves;
	}
}
