package src;

import h2d.col.Point;

typedef TileSettings = {
	var x:Int;
	var y:Int;
	var width:Int;
	var height:Int;
}

enum PieceType {
	Pawn;
	King;
	Queen;
	Bishop;
	Knight;
	Rook;
}

enum Color {
	Black;
	White;
}

enum Kind {
	Piece(pt:PieceType, c:Color);
	Cell(c:Color);
	SelectionCell(color:Int);
}

class AssetsManager {
	public static var instance(default, null):AssetsManager = new AssetsManager();

	public var tiles:h2d.Tile;

	private function new() {}

	public function load() {
		tiles = hxd.Res.chess.toTile();
	}

	public var initialXY:Map<Kind, TileSettings> = [
		Kind.Piece(PieceType.Pawn, Color.Black) => {
			x: 0,
			y: 64,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Pawn, Color.White) => {
			x: 64,
			y: 64,
			width: 64,
			height: 64
		},
		Kind.Cell(Color.Black) => {
			x: 0,
			y: 0,
			width: 64,
			height: 64
		},
		Kind.Cell(Color.White) => {
			x: 64,
			y: 0,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Rook, Color.Black) => {
			x: 128,
			y: 0,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Rook, Color.White) => {
			x: 128,
			y: 64,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Knight, Color.White) => {
			x: 192,
			y: 64,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Knight, Color.Black) => {
			x: 192,
			y: 0,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Bishop, Color.White) => {
			x: 256,
			y: 64,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Bishop, Color.Black) => {
			x: 256,
			y: 0,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Queen, Color.White) => {
			x: 320,
			y: 64,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.Queen, Color.Black) => {
			x: 320,
			y: 0,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.King, Color.White) => {
			x: 384,
			y: 64,
			width: 64,
			height: 64
		},
		Kind.Piece(PieceType.King, Color.Black) => {
			x: 384,
			y: 0,
			width: 64,
			height: 64
		}
	];

	public function loadTile(type:Kind) {
		var settings:TileSettings = initialXY[type];

		return tiles.sub(settings.x, settings.y, settings.width, settings.height);
	}

	public function loadEntity(type:Kind) {
		// Entities have animations inside them
		var settings:TileSettings = initialXY[type];

		var poly = new h2d.col.Polygon([ // TODO
			new Point(0, 0), new Point(64, 0), new Point(64, 64), new Point(0, 64)]);

		var polyCollider = poly.getCollider();

		var anim:h2d.Object;
		switch (type) {
			case SelectionCell(color):
				var temp = new h2d.Graphics();
				temp.beginFill(color);
				temp.drawRect(0, 0, 64, 64);
				temp.endFill();
				anim = temp;
			default:
				anim = new h2d.Anim([tiles.sub(settings.x, settings.y, settings.width, settings.height)]);
		}

		var spr = new h2d.Interactive(1, 1);
		spr.shape = polyCollider;
		spr.addChild(anim);

		return spr;
	}
}
