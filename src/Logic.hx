package src;

using src.Beaten;

import src.pieces.Piece;
import src.Constraints;

class Logic {
	private var pieces:Array<Array<Piece>>;
	private var drawer:Drawer;
	private var selected:Piece;
	private var highlightedEntites:Array<Entity> = [];
	private var beatenWhite: Array<Array<Bool>>;
	private var beatenBlack: Array<Array<Bool>>;
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
			for (type in highlighted) {
				addSelectionRectangle(type);
			}
		}
		iter.onOut = function(e:hxd.Event) {
			drawer.clearTemp();
		}
	}

	private function addSelectionRectangle(moveType:MoveType) {
		// TODO - learn how to parse;
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
				var goesTo = pieces[to.y][to.x];
				if (goesTo != null) {
					goesTo.remove();
				}

				pieces[to.y][to.x] = piece;
				pieces[piece.cellY][piece.cellX] = null;
				piece.moveTo(to.x, to.y);
				currentPlayer = currentPlayer == White ? Black : White;
		}
		// specific
		switch (move) {
			case Castling(to, rook):
				// мм... хардкод
				pieces[rook.cellY][rook.cellX] = null;
				pieces[to.y][to.x - 1] = rook;
				rook.moveTo(to.x - 1, to.y);
			case CastlingLong(to, rook):
				// TODO - мне пиздец не нравится, что управление pieces в каждом случае нужно делать руками
				// мб вынести во что-то?
				pieces[rook.cellY][rook.cellX] = null;
				pieces[to.y][to.x + 1] = rook;
				rook.moveTo(to.x + 1, to.y);
			case EnPassant(to, pawn):
				pawn.remove();
				pieces[pawn.cellY][pawn.cellX] = null;
			default:
		}

		beatenWhite = pieces.getBeatenCells(White);
		beatenBlack = pieces.getBeatenCells(Black);

	}

	public function startGame() {
		for (j in 0...Constraints.gameStart.length) {
			for (i in 0...Constraints.gameStart[0].length) {
				pieces[j][i] = src.pieces.PieceFactory.createPieceKind(Constraints.gameStart[j][i], i, j);
				if (pieces[j][i] != null)
					addPiece(pieces[j][i]);
			}
		}

		beatenWhite = pieces.getBeatenCells(White);
		beatenBlack = pieces.getBeatenCells(Black);
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
