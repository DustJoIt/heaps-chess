package src;


import src.pieces.Piece;
import src.Constraints;

class Logic {
	private var board:Board;
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
					trace(5);
				default:
			}
		});
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
		board.addPiece(piece, piece.cellX, piece.cellY);
		// Три функции - onOver - подсветка тех, куда он в теории может пойти (слабая)
		// OnClick - полная подстветка, создание "selection rectangles" - квадратиков для выбора...
		// По нажатию на квадратик для выбора перемещаем фигуру

		// TODO - мб переделать?
		var iter = piece.getInter();
		iter.onOver = function(e:hxd.Event) {
			if (selected == null) {
				showHovered(piece.canMoveTo(board));
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
			var highlighted = piece.canMoveTo(board);
			for (type in highlighted) {
				addSelectionRectangle(type);
			}
		}
		iter.onOut = function(e:hxd.Event) {
			drawer.clearTemp();
		}
	}

	private function addSelectionRectangle(moveType:MoveType) {
		var g:SelectionRectangle;
		switch (moveType) {
			case Move(to):
				g = new SelectionRectangle(to.x, to.y, 0x00FF00);
			case Capture(to):
				g = new SelectionRectangle(to.x, to.y, 0xFF0000);
			case Castling(to, rook) | CastlingLong(to, rook) :
				g = new SelectionRectangle(to.x, to.y, 0x0000FF);
			case EnPassant(to, pawn):
				g = new SelectionRectangle(to.x, to.y, 0x0000FF);
		}
		highlightedEntites.push(g);
		drawer.addPiece(g);

		g.getInter().onClick = function(e:hxd.Event) {
			processMove(selected, moveType);
			clickDeselect();
		}
	}

	private function processMove(piece:Piece, move:MoveType) {
		// generic
		switch (move) {
			case Move(to) | Capture(to) | Castling(to, _) | CastlingLong(to, _) |EnPassant(to, _):
				board.movePiece(piece, to.x, to.y);
				currentPlayer = currentPlayer == White ? Black : White;
		}
		// specific
		switch (move) {
			case Castling(to, rook):
				// мм... хардкод
				board.movePiece(rook, to.x - 1, to.y);
			case CastlingLong(to, rook):
				board.movePiece(rook, to.x + 1, to.y);
			case EnPassant(to, pawn):
				board.removePiece(pawn);
			default:
		}

		board.updateBeatenMaps();

	}

	public function startGame() {
		board = new Board(drawer);
		for (j in 0...Constraints.gameStart.length) {
			for (i in 0...Constraints.gameStart[0].length) {
				var toAdd = src.pieces.PieceFactory.createPieceKind(Constraints.gameStart[j][i], i, j);
				if (toAdd != null) 
					addPiece(toAdd);
			}
		}

		board.updateBeatenMaps();
	}

	private function showHovered(places:Array<MoveType>) {
		for (place in places) {
			switch (place) {
				case Move(to):
					drawer.addRectangle(to.x, to.y, 0x00FF00);
				case Capture( to):
					drawer.addRectangle(to.x, to.y, 0xFF0000);
				case Castling(to, rook) | CastlingLong(to, rook):
					drawer.addRectangle(to.x, to.y, 0x00FF00);
				case EnPassant(to, pawn):
					drawer.addRectangle(to.x, to.y, 0x00FF00);
			}
		}
	}
}
