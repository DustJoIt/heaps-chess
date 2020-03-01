package src.pieces;

interface IPiece extends src.IEntity.IEntityInteractable extends IMovable {

    public var color: src.AssetsManager.Color;

    // TODO: Rethink fucking structure
    public function moveTo(toX: Int, toY: Int): Void;
    public function select(): Void;
    public function deselect(): Void;
}