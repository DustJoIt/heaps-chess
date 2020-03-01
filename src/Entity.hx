package src;

import src.AssetsManager.Kind;

class Entity implements src.IEntity.IEntityInteractable {
	public var spr(default, null):h2d.Interactive;
	public var kind(default, null):Kind;

	public var x:Int;
	public var y:Int;

	public function new(kind:Kind, x:Int, y:Int) {
		this.kind = kind;
		this.x = x;
		this.y = y;

		spr = AssetsManager.instance.loadEntity(kind);
	}

	public function update(dt:Float) {
		// Это неправильно..
		// Entity - стоят на реальных позициях x,y
		spr.x = Std.int(x * 64);
		spr.y = Std.int(y * 64);
	}

	public function getObject() {
		return this.spr;
	}

	public function remove() {
		spr.remove();
	}
}
