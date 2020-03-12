package src;

import src.Constraints.Cell;
import src.AssetsManager.Color;
import src.pieces.Piece;

class Beaten {
	static public function getBeatenCells(pieces:Array<Array<Piece>>, color:Color): Array<Array<Bool>> {
		var map2 = pieces.map(row -> row.map(cell -> (return (cell != null) && (cell.color != color))));

		for (row in pieces) {
			for (cell in row) {
				if (cell == null)
					break;
				if (cell.color == color)
					break;

				var canGoTo = cell.getBeaten(pieces);
				for (move in canGoTo) {
					// TODO - ленивый костыль
					var move_cell:Cell = move.getParameters()[0];
					trace(move_cell);
					map2[move_cell.y][move_cell.x] = true;
				}
			}
        }
        
		return map2;
	}
}
