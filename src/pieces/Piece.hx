package src.pieces;

import src.AssetsManager.Kind;
import src.AssetsManager.PieceType;
import src.Constraints.MoveType;
import src.AssetsManager.Color;

class Piece extends src.CellEntity implements Interactable {
	public var color:src.AssetsManager.Color;

	public function new(kind:PieceType, color:Color, x:Int, y:Int) {
		super(Kind.Piece(kind, color), x, y);
		this.color = color;
	}

	public function moveTo(toX:Int, toY:Int) {
		this.cellX = toX;
		this.cellY = toY;
	}

	public function select():Void {
		this.spr.filter = new h2d.filter.Glow();
	}

	public function deselect():Void {
		this.spr.filter = null;
	}

	public function getInter():h2d.Interactive {
		return cast(this.spr, h2d.Interactive);
	}

	public function getBeaten(boardState: Board) {
		return canMoveTo(boardState);
	}

	public function canMoveTo(boardState: Board):Array<MoveType> {
		return [];
	}
}
