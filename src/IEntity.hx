package src;

import src.AssetsManager.Kind;

interface IEntity {
	public var x:Int;
	public var y:Int;
	
	public var kind(default, null):Kind;

	public function update(dt:Float):Void;
    public function getObject():h2d.Object;
	public function remove():Void;
}

interface IEntityInteractable extends IEntity {
    public function getObject():h2d.Interactive;
}