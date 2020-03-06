package src;

import src.Constraints.BoardMove;
import src.pieces.IPiece;

interface IMovable {
    function canMoveTo(boardState: Array<Array<IPiece>>): Array<BoardMove>;
}