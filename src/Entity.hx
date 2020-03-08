package src;

import src.AssetsManager.Kind;

class Entity {
	private var spr(default, null):h2d.Object;

	public var kind(default, null):Kind;
	public var x(get, set):Float;
	public var y(get, set):Float;

	public function get_x() {
		return spr.x;
	}

	public function set_x(x) {
		return this.spr.x = x;
	}

	public function get_y() {
		return spr.x;
	}

	public function set_y(y) {
		return this.spr.y = y;
	}

	public function new(kind:Kind, x:Float, y:Float) {
		spr = AssetsManager.instance.loadEntity(kind);
		this.kind = kind;
		this.x = x;
		this.y = y;
	}

	public function update(dt:Float) {}

	public function getObject() {
		return spr;
	}

	public function remove() {
		spr.remove();
	}
}
