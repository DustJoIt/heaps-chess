package src.pieces;

import src.pieces.Piece;
import src.Constraints.BoardMove;
import src.AssetsManager.Color;

using src.CellInt;

class Pawn extends Piece {
	private var moved:Bool = false;

	override public function new(color:Color, x:Int, y:Int) {
		super(Pawn, color, x, y);
	}

	override public function moveTo(toX:Int, toY:Int) {
		super.moveTo(toX, toY);
		moved = true;
	};

	override public function canMoveTo(boardState:Array<Array<Piece>>) {
		var direction = color == Black ? 1 : -1;

		var moves:Array<BoardMove> = [];

		// Moving
		for (i in 1...(2 + (moved ? 0 : 1))) {
			var tY = cellY + i * direction;
			if (tY.isOutOfBounds() || boardState[tY][cellX] != null)
				break;

			moves.push({
				x: cellX,
				y: tY,
				// TODO - change to manager
				color: 0x00FF00
			});
		}

		// Attacking
		for (i in [-1, 1]) {
			var tX = cellX + i;
			var tY = cellY + direction;
			if (tY.isOutOfBounds())
				break;
			if (tX.isOutOfBounds() || boardState[tY][tX] == null)
				continue;

			if (boardState[tY][tX].color == color)
				continue;

			moves.push({
				x: tX,
				y: tY,
				// TODO - change to manager
				color: 0xFF0000
			});
		}

		return moves;
	}
}
