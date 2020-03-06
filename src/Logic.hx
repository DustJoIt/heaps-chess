package src;

import src.IEntity.IEntityInteractable;
import src.pieces.IPiece;
import src.Constraints;

class Logic {
	private var pieces:Array<Array<IPiece>>;
	private var drawer:Drawer;
	private var selected:IPiece;
	private var highlighted:Array<BoardMove> = [];
	private var highlightedEntites:Array<IEntityInteractable> = [];

	public function new(scene:h2d.Scene) {
		drawer = new Drawer(scene);

		scene.addEventListener(e -> {
			switch (e.kind) {
				case EPush:
					clickDeselect();
				case EKeyDown:
					trace(5);
				default:
			}
		});

		pieces = [
			for (j in 0...Constraints.BOARD_SIZE) [for (i in 0...Constraints.BOARD_SIZE) null]
		];
	}

	public function removeEntities(arr:Array<IEntityInteractable>) {
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

	private function addPiece(piece:IPiece) {
		drawer.addPiece(piece);
		pieces[piece.y][piece.x] = piece;
		// Три функции - onOver - подсветка тех, куда он в теории может пойти (слабая)
		// OnClick - полная подстветка
		// ? - сделать шаг - ?
		piece.getObject().onOver = function(e:hxd.Event) {
			if (selected == null) {
				highlighted = piece.canMoveTo(pieces);
				showHovered(highlighted);
				drawer.addRectangle(piece.x, piece.y, 0xAAAAAA);
			}
		}
		piece.getObject().onClick = function(e:hxd.Event) {
			clickDeselect();
			selected = piece;
			piece.select();
			highlighted = piece.canMoveTo(pieces);
			highlightedEntites = highlighted.map(function(place):IEntityInteractable {
				var g:IEntityInteractable = new src.SelectionRectangle(place.x, place.y, place.color);
				addSelectionRectangle(g);
				return g;
			});
		}
		piece.getObject().onOut = function(e:hxd.Event) {
			drawer.clearTemp();
			highlighted = [];
		}
	}

	private function addSelectionRectangle(entity:IEntityInteractable) {
		drawer.addPiece(entity);
		entity.getObject().onClick = function(e:hxd.Event) {
			processMove(selected, entity.x, entity.y);
			clickDeselect();
		}
	}

	private function processMove(piece:IPiece, toX:Int, toY:Int) {
		var goesTo = pieces[toY][toX];
		if (goesTo != null) {
			goesTo.remove();
		}

		pieces[toY][toX] = piece;
		pieces[piece.y][piece.x] = null;
		piece.moveTo(toX, toY);
	}

	public function startGame() {
		for (i in 0...8) {
			// Вынести в фабрику
			var piece:IPiece = new src.pieces.Pawn(Black, i, 0);
			addPiece(piece);
		}
		var piece:IPiece = new src.pieces.Pawn(Black, 3, 1);
		addPiece(piece);
		piece = new src.pieces.Pawn(White, 4, 1);
		addPiece(piece);
	}

	private function showHovered(places:Array<BoardMove>) {
		for (place in places) {
			drawer.addRectangle(place.x, place.y, place.color);
		}
	}
}
