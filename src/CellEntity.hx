package src;

import src.AssetsManager.Kind;

class CellEntity extends Entity implements ICellEntity {
	public function new(kind:Kind, x:Float, y:Float) {
		super(kind, x * Constraints.CELL_WIDTH, y * Constraints.CELL_HEIGHT);
	}

	public var cellX(get, set):Int;
	public var cellY(get, set):Int;

	public function get_cellX()
		return Std.int(spr.x / Constraints.CELL_WIDTH);

	public function set_cellX(x:Int)
		return Std.int(spr.x = x * Constraints.CELL_WIDTH);

	public function get_cellY()
		return Std.int(spr.y / Constraints.CELL_HEIGHT);

	public function set_cellY(y:Int)
		return Std.int(spr.y = y * Constraints.CELL_HEIGHT);
}
