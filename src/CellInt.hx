package src;

class CellInt {
	public static function isOutOfBounds(a:Int) {
		return (a >= Constraints.BOARD_SIZE || a < 0);
	}
}
