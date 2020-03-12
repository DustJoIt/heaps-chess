package src.pieces;

import src.pieces.Piece;
import src.Constraints.MoveType;
import src.AssetsManager.Color;

using src.CellInt;
using src.Constraints;

class Pawn extends Piece {
	private var moved:Bool = false;

	override public function new(color:Color, x:Int, y:Int) {
		super(Pawn, color, x, y);
	}

	override public function moveTo(toX:Int, toY:Int) {
		super.moveTo(toX, toY);
		moved = true;
	};

	override public function getBeaten(boardState:Array<Array<Piece>>) {
		var direction = color == Black ? 1 : -1;

		var moves:Array<MoveType> = [];

		// Attacking
		for (i in [-1, 1]) {
			var tX = cellX + i;
			var tY = cellY + direction;
			if (tY.isOutOfBounds())
				break;
			if (tX.isOutOfBounds())
				continue;

			if (boardState[tY][tX] != null && boardState[tY][tX].color == color)
				continue;

			moves.push(Capture(this.createCell(tX, tY)));
		}

		return moves;
	}

	override public function canMoveTo(boardState:Array<Array<Piece>>) {
		var direction = color == Black ? 1 : -1;

		var moves:Array<MoveType> = [];
		// Moving
		for (i in 1...(2 + (moved ? 0 : 1))) {
			var tY = cellY + i * direction;
			if (tY.isOutOfBounds() || boardState[tY][cellX] != null)
				break;

			moves.push(Move(this.createCell(cellX, tY)));
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

			moves.push(Capture(this.createCell(tX, tY)));
		}

		return moves;
	}
}
