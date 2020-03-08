package src;

import src.pieces.Piece;
import src.Constraints;

class Logic {
	private var pieces:Array<Array<Piece>>;
	private var drawer:Drawer;
	private var selected:Piece;
	private var highlightedEntites:Array<Entity> = [];
	private var currentPlayer:AssetsManager.Color = White;

	public function new(scene:h2d.Scene) {
		drawer = new Drawer(scene);

		scene.addEventListener(e -> {
			switch (e.kind) {
				case EPush:
					clickDeselect();
				case EKeyDown:
				// trace(5);
				default:
			}
		});

		pieces = [
			for (j in 0...Constraints.BOARD_SIZE) [for (i in 0...Constraints.BOARD_SIZE) null]
		];
	}

	public function removeEntities<T:Entity>(arr:Array<T>) {
		for (entity in arr) {
			entity.remove();
		}
	}

	private function clickDeselect() {
		removeEntities(highlightedEntites);
		if (selected != null)
			selected.deselect();
		selected = null;
	}

	public function update(dt:Float) {
		drawer.update(dt);
	}

	private function addPiece(piece:Piece) {
		drawer.addPiece(piece);
		pieces[piece.cellY][piece.cellX] = piece;
		// Три функции - onOver - подсветка тех, куда он в теории может пойти (слабая)
		// OnClick - полная подстветка, создание "selection rectangles" - квадратиков для выбора...
		// По нажатию на квадратик для выбора перемещаем фигуру

		// TODO - мб переделать?
		var iter = piece.getInter();
		iter.onOver = function(e:hxd.Event) {
			if (selected == null) {
				showHovered(piece.canMoveTo(pieces));
				drawer.addRectangle(piece.cellX, piece.cellY, 0xAAAAAA);
			}
		}
		iter.onClick = function(e:hxd.Event) {
			#if !debug
			if (piece.color != currentPlayer)
				return;
			#end
			drawer.clearTemp();
			clickDeselect();
			selected = piece;
			piece.select();
			var highlighted = piece.canMoveTo(pieces);
			highlightedEntites = highlighted.map(function(place):Entity {
				var g = new src.SelectionRectangle(place.x, place.y, place.color);
				addSelectionRectangle(g);
				return g;
			});
		}
		iter.onOut = function(e:hxd.Event) {
			drawer.clearTemp();
		}
	}

	private function addSelectionRectangle<T:(CellEntity & Interactable)>(entity:T) {
		drawer.addPiece(entity);

		entity.getInter().onClick = function(e:hxd.Event) {
			processMove(selected, entity.cellX, entity.cellY);
			clickDeselect();
		}
	}

	private function processMove(piece:Piece, toX:Int, toY:Int) {
		var goesTo = pieces[toY][toX];
		if (goesTo != null) {
			goesTo.remove();
		}

		pieces[toY][toX] = piece;
		pieces[piece.cellY][piece.cellX] = null;
		piece.moveTo(toX, toY);
		currentPlayer = currentPlayer == White ? Black : White;
	}

	public function startGame() {
		for (j in 0...Constraints.gameStart.length) {
			for (i in 0...Constraints.gameStart[0].length) {
				pieces[j][i] = src.pieces.PieceFactory.createPieceKind(Constraints.gameStart[j][i], i, j);
				if (pieces[j][i] != null)
					addPiece(pieces[j][i]);
			}
		}
	}

	private function showHovered(places:Array<BoardMove>) {
		for (place in places) {
			drawer.addRectangle(place.x, place.y, place.color);
		}
	}
}
