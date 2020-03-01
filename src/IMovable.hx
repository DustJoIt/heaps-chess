package src;

import src.Constraints.BoardMove;

interface IMovable {
    function canMoveTo(): Array<BoardMove>;
}