package src;

import src.AssetsManager.Kind;

interface IEntity {
	private var spr(default, null):h2d.Object;

	public var kind(default, null):Kind;
	public var x(get, set):Float;
	public var y(get, set):Float;

	public function update(dt:Float): Void ;
	public function getObject(): h2d.Object;
	public function remove(): Void;
}
