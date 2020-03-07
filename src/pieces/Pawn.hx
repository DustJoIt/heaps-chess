package src.pieces;

import src.AssetsManager.Color;
import src.Constraints.BoardMove;
import src.pieces.Piece;

class Pawn extends Piece {
	private var moved:Bool = false;
	public function new(color:Color, x:Int, y:Int) {
		super(Kind.Piece(Pawn, color), x, y);
		this.color = color;
	}

	override public function update(dt:Float) {
		super.update(dt);
	}

	override public function select():Void {
		this.spr.filter = new h2d.filter.Glow();
	}

	override public function deselect():Void {
		this.spr.filter = null;
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
			if (tY >= Constraints.BOARD_SIZE || tY < 0 || boardState[tY][cellX] != null)
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
			if (tY < 0 || tY >= Constraints.BOARD_SIZE)
				break;
			if (tX > Constraints.BOARD_SIZE || tX < 0 || boardState[tY][tX] == null)
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
