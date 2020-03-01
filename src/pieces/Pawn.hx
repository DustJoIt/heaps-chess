package src.pieces;

import src.AssetsManager.Color;

using src.Constraints;

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

    public function moveTo(toX: Int, toY: Int) {
		this.x = toX;
		this.y = toY;
	};

	public function canMoveTo() {
		var direction = color == Black ? 1 : -1;

		var moves:Array<BoardMove> = [
			{
				x: this.x,
				y: this.y + direction,
				canAttack: false,
				canOnlyAttack: false,
				pieceColor: this.color
			}
		];

		if (!moved) {
			moves.push({
				x: this.x,
				y: this.y + direction * 2,
				canAttack: false,
				canOnlyAttack: false,
				pieceColor: this.color
			});
		}

		moves.push({
			x: this.x - 1,
			y: this.y + direction,
			canAttack: true,
			canOnlyAttack: true,
			pieceColor: this.color
		});
		moves.push({
			x: this.x + 1,
			y: this.y + direction,
			canAttack: true,
			canOnlyAttack: true,
			pieceColor: this.color
		});

		return moves.filterOut();
	}
}
