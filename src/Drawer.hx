package src;

import src.AssetsManager.Color;

class Drawer {
	private var world:h2d.Layers;
	private var stage:h2d.Scene;
	private var entites:Array<IEntity> = [];
	private var temp: Array<h2d.Object> = [];

	private final CELL_WIDTH = 64;
	private final CELL_HEIGHT = 64;

	public function new(parent:h2d.Scene) {
		this.world = new h2d.Layers(parent);
		this.stage = parent;

		initializeBoard();
	}

	private function initializeBoard() {
		var boardLevel = new h2d.TileGroup(AssetsManager.instance.tiles);

		for (i in 0...src.Constraints.BOARD_SIZE) {
			for (j in 0...src.Constraints.BOARD_SIZE) {
				var currColor = ((i + j) % 2 == 0) ? Color.White : Color.Black;
				boardLevel.add(i * CELL_WIDTH, j * CELL_HEIGHT, AssetsManager.instance.loadTile(Cell(currColor)));
			}
		}

		world.add(boardLevel, 0);

		centerWorld();
	};

	public function centerWorld() {
		var bounds = world.getBounds();

		world.x = (stage.width - bounds.width) / 2;
		world.y = (stage.height - bounds.height) / 2;
	}

	public function update(dt:Float) {
		for (entity in entites) {
			entity.update(dt);
		}
	}

	public function addPiece(enitity:IEntity) {
		// TODO  подумать
		this.world.add(enitity.getObject(), 5);
		this.entites.push(enitity);
	}

	public function addRectangle(x: Int, y: Int, color: Int, fill = 0.5) {
		var g = new h2d.Graphics();
		g.beginFill(color);
		g.drawRect(x * 64, y * 64, CELL_WIDTH, CELL_HEIGHT);
		// g.drawRect(x * CELL_WIDTH, y * CELL_HEIGHT, CELL_WIDTH, 2);
		// g.drawRect(x * CELL_WIDTH, y * CELL_HEIGHT, 2, CELL_HEIGHT);
		// g.drawRect((x + 1)* CELL_WIDTH, y * CELL_HEIGHT, 2, CELL_HEIGHT);
		// g.drawRect(x * CELL_WIDTH, (y + 1) * CELL_HEIGHT, CELL_WIDTH, 2);
		g.endFill();
		world.add(g, 1);
		temp.push(g);
	}

	public function clearTemp() {
		for (obj in temp) {
			obj.remove();
		}
		temp = [];
	}

	public function removePiece(entity:Entity) {
		entity.remove();
		this.entites.remove(entity);
	}
}
