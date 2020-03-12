package src.pieces;

using src.Constraints;
using src.CellInt;

import src.AssetsManager.Color;
import src.Constraints.MoveType;

class Bishop extends Piece {
	override public function new(color:Color, x:Int, y:Int) {
		super(Bishop, color, x, y);
	}

	override public function canMoveTo(boardState:Array<Array<Piece>>):Array<MoveType> {
		var moves:Array<MoveType> = [];

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
					moves.push(Move(this.createCell(tX, tY)));
				} else {
					moves.push(Capture(this.createCell(tX, tY)));
					break;
				}

				tX +=  dirX;
				tY +=  dirY;
			}
		}

		return moves;
	}
}
