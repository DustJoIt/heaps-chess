package src.pieces;

import src.Constraints.BoardMove;

class Piece extends src.CellEntity implements Interactable {
	public var color:src.AssetsManager.Color;

	public function moveTo(toX:Int, toY:Int) {
		this.cellX = toX;
		this.cellY = toY;
	};

	public function select() {};

	public function getInter():h2d.Interactive {
		return cast(this.spr, h2d.Interactive);
	}

	public function canMoveTo(boardState:Array<Array<Piece>>):Array<BoardMove> {
		return [];
	};

	public function deselect() {};
}
