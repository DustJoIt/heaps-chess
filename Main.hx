import src.AssetsManager;

class Main extends hxd.App {
	// Цель проекта - сделать базовые шахматы
	public var logic:src.Logic;

	override function init() {
		super.init();
		AssetsManager.instance.load();

		logic = new src.Logic(s2d);

		logic.startGame();
	}

	override function update(dt:Float) {
		logic.update(dt);
	}

	static function main() {
		hxd.Res.initEmbed();

		new Main();
	}
}
