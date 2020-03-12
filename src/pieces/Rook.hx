package src.pieces;

import src.AssetsManager.Color;
import src.Constraints.MoveType;

using src.CellInt;
using src.Constraints;

class Rook extends Piece {
	public var moved = false;

	override public function new(color:Color, x:Int, y:Int) {
		super(Rook, color, x, y);
	}

	override public function moveTo(toX:Int, toY:Int) {
		super.moveTo(toX, toY);
		moved = true;
	}

	override public function canMoveTo(boardState:Array<Array<Piece>>):Array<MoveType> {
		var moves:Array<MoveType> = [];

		for (isX in [true, false]) {
			for (direction in [-1, 1]) {
				for (i in 1...Constraints.BOARD_SIZE) {
					var tX = cellX + i * direction * (isX ? 1 : 0);
					var tY = cellY + i * direction * (isX ? 0 : 1);

					if (tX.isOutOfBounds() || tY.isOutOfBounds())
						break;

					var lookingAt = boardState[tY][tX];
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

		return moves;
	}
}
