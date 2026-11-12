class_name BoardState

var _pieces: Array[PieceState]
var _selected_piece: StringName

func initialize() -> void:
	_pieces = []
	_selected_piece = ""

func initialize_layout() -> void:
	var cao_cao: PieceState = PieceState.new()
	cao_cao.initialize(1, 0, 2, 2, Constants.PIECE_TYPE.MAIN, "cao_cao")
	_pieces.append(cao_cao)
	
	var zhang_fei: PieceState = PieceState.new()
	zhang_fei.initialize(0, 0, 2, 1, Constants.PIECE_TYPE.SECONDARY, "zhang_fei")
	_pieces.append(zhang_fei)
	
	var zhao_yun: PieceState = PieceState.new()
	zhao_yun.initialize(3, 0, 2, 1, Constants.PIECE_TYPE.SECONDARY, "zhao_yun")
	_pieces.append(zhao_yun)
	
	var ma_chao: PieceState = PieceState.new()
	ma_chao.initialize(0, 2, 2, 1, Constants.PIECE_TYPE.SECONDARY, "ma_chao")
	_pieces.append(ma_chao)
	
	var huang_zhong: PieceState = PieceState.new()
	huang_zhong.initialize(3, 2, 2, 1, Constants.PIECE_TYPE.SECONDARY, "huang_zhong")
	_pieces.append(huang_zhong)
	
	var guan_yu: PieceState = PieceState.new()
	guan_yu.initialize(1, 2, 1, 2, Constants.PIECE_TYPE.SECONDARY, "guan_yu")
	_pieces.append(guan_yu)
	
	var pawn_1: PieceState = PieceState.new()
	pawn_1.initialize(1, 3, 1, 1, Constants.PIECE_TYPE.SMALL, "pawn_1")
	_pieces.append(pawn_1)

	var pawn_2: PieceState = PieceState.new()
	pawn_2.initialize(2, 3, 1, 1, Constants.PIECE_TYPE.SMALL, "pawn_2")
	_pieces.append(pawn_2)
	
	var pawn_3: PieceState = PieceState.new()
	pawn_3.initialize(0, 4, 1, 1, Constants.PIECE_TYPE.SMALL, "pawn_3")
	_pieces.append(pawn_3)
	
	var pawn_4: PieceState = PieceState.new()
	pawn_4.initialize(3, 4, 1, 1, Constants.PIECE_TYPE.SMALL, "pawn_4")
	_pieces.append(pawn_4)

func get_piece(piece_id: StringName) -> PieceState:
	var piece_index: int = _pieces.find_custom(func(piece: PieceState) -> bool : return piece._id == piece_id)
	return _pieces[piece_index] if piece_index >= 0 else null

func get_selected_piece() -> PieceState:
	return get_piece(_selected_piece)

func is_in_bounds(position: Vector2i) -> bool:
	return position.x >= 0 and position.y >= 0 \
		and position.x < Constants.BOARD_WIDTH \
		and position.y < Constants.BOARD_HEIGHT

func is_occupied_by_other(position: Vector2i, moving: PieceState) -> bool:
	for piece: PieceState in _pieces:
		if piece == moving:
			continue
		if piece.contains_point(position.x, position.y):
			return true
	return false

func leading_positions(piece: PieceState, direction: Constants.DIRECTION) -> Array[Vector2i]:
	var positions: Array[Vector2i] = []
	match direction:
		Constants.DIRECTION.UP:
			for x: int in range(piece._width):
				positions.append(Vector2i(piece._x_position + x, piece._y_position - 1))
		Constants.DIRECTION.DOWN:
			for x: int in range(piece._width):
				positions.append(Vector2i(piece._x_position + x, piece._y_position + piece._height))
		Constants.DIRECTION.LEFT:
			for y: int in range(piece._height):
				positions.append(Vector2i(piece._x_position - 1, piece._y_position + y))
		Constants.DIRECTION.RIGHT:
			for y: int in range(piece._height):
				positions.append(Vector2i(piece._x_position + piece._width, piece._y_position + y))
	return positions

func is_at_exit(piece: PieceState) -> bool:
	return piece._type == Constants.PIECE_TYPE.MAIN \
		and piece._x_position == 1 \
		and piece._y_position == 3

func has_escaped(piece: PieceState) -> bool:
	return piece._type == Constants.PIECE_TYPE.MAIN \
		and piece._x_position == 1 \
		and piece._y_position >= 4

func can_step(piece: PieceState, direction: Constants.DIRECTION) -> bool:
	if piece._type == Constants.PIECE_TYPE.MAIN \
			and direction == Constants.DIRECTION.DOWN \
			and is_at_exit(piece):
		return true

	for position: Vector2i in leading_positions(piece, direction):
		if not is_in_bounds(position) or is_occupied_by_other(position, piece):
			return false
	return true

func try_step(piece: PieceState, direction: Constants.DIRECTION) -> bool:
	if not can_step(piece, direction):
		return false
	piece.move(direction)
	return true

func apply_position(piece: PieceState, position: Vector2i) -> void:
	piece._x_position = position.x
	piece._y_position = position.y

func direction_for_click(piece: PieceState, click: Vector2i) -> int:
	if piece.contains_point(click.x, click.y):
		return -1
	var same_column: bool = click.x >= piece._x_position \
		and click.x < piece._x_position + piece._width
	var same_row: bool = click.y >= piece._y_position \
		and click.y < piece._y_position + piece._height
	if same_column and click.y < piece._y_position:
		return Constants.DIRECTION.UP
	if same_column and click.y >= piece._y_position + piece._height:
		return Constants.DIRECTION.DOWN
	if same_row and click.x < piece._x_position:
		return Constants.DIRECTION.LEFT
	if same_row and click.x >= piece._x_position + piece._width:
		return Constants.DIRECTION.RIGHT
	return -1

func desired_origin_after_slide(piece: PieceState, click: Vector2i, direction: int) -> Vector2i:
	var origin: Vector2i = Vector2i(piece._x_position, piece._y_position)
	match direction:
		Constants.DIRECTION.UP:
			origin.y = click.y
		Constants.DIRECTION.DOWN:
			origin.y = click.y - piece._height + 1
		Constants.DIRECTION.LEFT:
			origin.x = click.x
		Constants.DIRECTION.RIGHT:
			origin.x = click.x - piece._width + 1
	return origin

func farthest_reachable(piece: PieceState, direction: int, desired: Vector2i) -> Vector2i:
	var saved: Vector2i = Vector2i(piece._x_position, piece._y_position)
	while Vector2i(piece._x_position, piece._y_position) != desired:
		if not try_step(piece, direction):
			break
	var reached: Vector2i = Vector2i(piece._x_position, piece._y_position)
	apply_position(piece, saved)
	return reached

func resolve_move(piece_id: StringName, click: Vector2i) -> Vector2i:
	var piece: PieceState = get_piece(piece_id)
	if piece == null:
		return Vector2i(-1, -1)
	var from: Vector2i = Vector2i(piece._x_position, piece._y_position)
	var direction: int = direction_for_click(piece, click)
	if direction < 0:
		return from
	var desired: Vector2i = desired_origin_after_slide(piece, click, direction)
	return farthest_reachable(piece, direction, desired)

func try_move(piece_id: StringName, click: Vector2i) -> Vector2i:
	var piece: PieceState = get_piece(piece_id)
	if piece == null:
		return Vector2i(-1, -1)
	var reached: Vector2i = resolve_move(piece_id, click)
	apply_position(piece, reached)
	return reached
