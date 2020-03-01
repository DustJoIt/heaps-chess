package src;

class SelectionRectangle extends Entity {
	var disp:h2d.Tile;

	public function new(x:Int, y:Int, color:Int) {
		super(SelectionCell(color), x, y);
		disp = hxd.Res.normalmap.toTile();
		this.spr.filter = new h2d.filter.Displacement(disp);
    }
    
    override public function update(dt: Float) {
		super.update(dt);
		disp.scrollDiscrete(10*dt, 6*dt);
    }
}
