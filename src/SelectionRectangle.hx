package src;

class SelectionRectangle extends CellEntity implements Interactable {
	var disp:h2d.Tile;

	public function new(x:Int, y:Int, color:Int) {
		super(SelectionCell(color), x, y);
		disp = hxd.Res.normalmap.toTile();
		this.spr.filter = new h2d.filter.Displacement(disp);
	}

	public function getInter():h2d.Interactive {
		return cast(this.spr, h2d.Interactive);
	}

	override public function update(dt:Float) {
		disp.scrollDiscrete(10 * dt, 6 * dt);
	}
}
