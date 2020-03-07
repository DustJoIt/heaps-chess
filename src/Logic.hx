package src;

import src.pieces.Piece;
import src.Constraints;

class Logic {
	private var pieces:Array<Array<Piece>>;
	private var drawer:Drawer;
	private var selected:Piece;
	private var highlightedEntites:Array<IEntity> = [];
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

	public function removeEntities<T:IEntity>(arr:Array<T>) {
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
		piece.getInter().onOver = function(e:hxd.Event) {
			if (selected == null) {
				showHovered(piece.canMoveTo(pieces));
				drawer.addRectangle(piece.cellX, piece.cellY, 0xAAAAAA);
			}
		}
		piece.getInter().onClick = function(e:hxd.Event) {
			if (piece.color != currentPlayer)
				return;
			clickDeselect();
			selected = piece;
			piece.select();
			var highlighted = piece.canMoveTo(pieces);
			highlightedEntites = highlighted.map(function(place):IEntity {
				var g = new src.SelectionRectangle(place.x, place.y, place.color);
				addSelectionRectangle(g);
				return g;
			});
		}
		piece.getInter().onOut = function(e:hxd.Event) {
			drawer.clearTemp();
		}
	}

	private function addSelectionRectangle<T:(ICellEntity & Interactable)>(entity:T) {
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
		for (i in 0...8) {
			// Вынести в фабрику
			var piece:Piece = new src.pieces.Pawn(Black, i, 0);
			addPiece(piece);
		}
		var piece:Piece = new src.pieces.Pawn(Black, 3, 1);
		addPiece(piece);
		piece = new src.pieces.Pawn(White, 4, 1);
		addPiece(piece);
		for (i in 0...8) {
			// Вынести в фабрику
			var piece:Piece = new src.pieces.Pawn(White, i, 7);
			addPiece(piece);
		}
	}

	private function showHovered(places:Array<BoardMove>) {
		for (place in places) {
			drawer.addRectangle(place.x, place.y, place.color);
		}
	}
}
