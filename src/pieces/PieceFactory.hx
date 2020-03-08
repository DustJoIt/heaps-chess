package src.pieces;

import src.AssetsManager.PieceType;
import src.AssetsManager.Kind;
import src.AssetsManager.Color;

class PieceFactory {

    static public function createPiece(type: PieceType, color: Color, x: Int, y: Int): Piece {
        switch (type) {
            case Pawn:
                return new Pawn(color, x, y);
            case King:
                return new King(color, x, y);
            case Queen:
                return new Queen(color, x, y);
            case Bishop:
                return new Bishop(color, x, y);
            case Knight:
                return new Knight(color, x,y);
            case Rook:
                return new Rook(color, x, y);
        }
    }

    static public function createPieceKind(kind: Kind, x:Int, y:Int) {
        if (kind == null)
            return null;
        switch (kind) {
            case Piece(pt, c):
                return PieceFactory.createPiece(pt, c, x, y);
            default:
                return null;
        }
    }
}