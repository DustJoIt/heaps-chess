package src.pieces;

using src.Constraints;
using src.CellInt;
using src.Beaten;

import src.AssetsManager.Color;
import src.Constraints.MoveType;

class King extends Piece {
	public var moved = false;

	override public function new(color:Color, x:Int, y:Int) {
		super(King, color, x, y);
	}

	override public function moveTo(toX:Int, toY:Int) {
		super.moveTo(toX, toY);
		moved = true;
	}


	override public function getBeaten(boardState:Board) {
		var moves:Array<MoveType> = [];

		for (move in [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]) {
			var tX = move[0] + cellX;
			var tY = move[1] + cellY;

			// TODO - рокировка

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

	override public function canMoveTo(boardState:Board):Array<MoveType> {
		var moves:Array<MoveType> = [];

		for (move in [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]) {
			var tX = move[0] + cellX;
			var tY = move[1] + cellY;

			// TODO - рокировка

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

		if (!moved) {
			// Рокировка короткая
			var lookTo = boardState.getPiece(cellX + 3, cellY);
			if (Std.is(lookTo, Rook) && lookTo.color == color && !cast(lookTo, Rook).moved) {
				var flag = true;
				for (i in 1...3) {
					var beatenMap = boardState.getBeatenMap(color);  
					var curr = boardState.getPiece(cellX + i, cellY);
					trace(beatenMap.getCell(cellX + i, cellY));
					if (curr != null || beatenMap.getCell(cellX + i, cellY)) {
						flag = false;
						break;
					}
				}

				if (flag) {
					moves.push(Castling(this.createCell(cellX + 2, cellY), lookTo));
				}
			}
		}

		return moves;
	}
}
