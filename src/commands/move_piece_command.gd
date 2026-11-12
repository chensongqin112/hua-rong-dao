class_name MovePieceCommand extends Command

var _board: BoardState
var _piece_id: StringName
var _from: Vector2i
var _to: Vector2i
var _click: Vector2i

func _init(board: BoardState, piece_id: StringName, click: Vector2i) -> void:
	_board = board
	_piece_id = piece_id
	_click = click

func get_piece_id() -> StringName:
	return _piece_id

func execute() -> bool:
	var piece: PieceState = _board.get_piece(_piece_id)
	if piece == null:
		return false

	_from = Vector2i(piece._x_position, piece._y_position)
	_to = _board.try_move(_piece_id, _click)
	return _to != _from

func undo() -> void:
	var piece: PieceState = _board.get_piece(_piece_id)
	if piece == null:
		return

	_board.apply_position(piece, _from)
