package src.pieces;

import src.AssetsManager.Color;
import src.Constraints.BoardMove;

class Pawn extends Entity implements src.pieces.IPiece {
	private var moved:Bool = false;

	public var color:Color;

	public function new(color:Color, x:Int, y:Int) {
		super(Kind.Piece(Pawn, color), x, y);
		this.color = color;
	}

	override public function update(dt:Float) {
		super.update(dt);
	}

	public function select():Void {
		this.spr.filter = new h2d.filter.Glow();
	}

	public function deselect():Void {
		this.spr.filter = null;
	}

	public function moveTo(toX:Int, toY:Int) {
		this.x = toX;
		this.y = toY;
		moved = true;
	};

	public function canMoveTo(boardState:Array<Array<IPiece>>) {
		var direction = color == Black ? 1 : -1;

		var moves:Array<BoardMove> = [];

		// Moving
		for (i in 1...(2 + (moved ? 0 : 1))) {
			var tY = y + i * direction;
			if (tY >= Constraints.BOARD_SIZE || tY < 0 || boardState[tY][x] != null)
				break;

			moves.push({
				x: this.x,
				y: tY,
				// TODO - change to manager
				color: 0x00FF00
			});
		}

		// Attacking
		for (i in [-1, 1]) {
			var tX = x + i;
			var tY = y + direction;
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
