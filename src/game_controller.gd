class_name GameController extends Node

var _game_state_holder: GameStateHolder
var _state: GameState:
	get: return _game_state_holder.get_state()
var _views: Dictionary = {}   # piece_id -> PieceView node
var _num_moves: Label
var _game_end_window: Window
var _invoker: CommandInvoker = CommandInvoker.new()

func bind_services(gsh: GameStateHolder) -> void:
	_game_state_holder = gsh

func start() -> void:
	_state._status = Constants.GAME_STATUS.ACTIVE
	_state._moves = 0
	_refresh_move_label()

func bind_board(board_view: BoardBackgroundContext) -> void:
	board_view.board_clicked.connect(_on_board_clicked)

func bind_piece(piece_view: PieceContext) -> void:
	var state: PieceState = _state._board.get_piece(piece_view.piece_id)
	_views[piece_view.piece_id] = piece_view
	piece_view.clicked.connect(_on_piece_clicked)
	piece_view.sync_from_state(state)

func bind_ui(num_moves: Label, game_end_window: Window) -> void:
	_num_moves = num_moves
	_game_end_window = game_end_window
	_game_end_window.close_requested.connect(func() -> void: _game_end_window.visible = false)
	_refresh_move_label()
	
func _on_board_clicked(mouse_position: Vector2) -> void:
	print("Board is clicked")
	var piece_id: StringName = _state._board._selected_piece
	if piece_id == &"":
		return

	var click: Vector2i = _get_state_position_from_screen_position(mouse_position)
	var command: MovePieceCommand = MovePieceCommand.new(_state._board, piece_id, click)

	if _invoker.execute(command):
		_state._moves = _invoker.undo_count()
		_sync_piece_view(piece_id)
		_refresh_move_label()
		_update_game_state()

	_state._board._selected_piece = &""
	_refresh_selection_highlight()

func undo_move() -> void:
	var command: Command = _invoker.undo()
	if command == null:
		return
	var move: MovePieceCommand = command as MovePieceCommand
	_state._moves = _invoker.undo_count()
	_sync_piece_view(move.get_piece_id())
	_refresh_move_label()

func redo_move() -> void:
	var command: Command = _invoker.redo()
	if command == null:
		return
	var move: MovePieceCommand = command as MovePieceCommand
	_state._moves = _invoker.undo_count()
	_sync_piece_view(move.get_piece_id())
	_refresh_move_label()

func _sync_piece_view(piece_id: StringName) -> void:
	var piece_state: PieceState = _state._board.get_piece(piece_id)
	var piece_view: PieceContext = _views[piece_id]
	piece_view.sync_from_state(piece_state)

func _refresh_move_label() -> void:
	if _num_moves:
		_num_moves.text = "Moves: " + str(_state._moves)

func _get_state_position_from_screen_position(screen_position: Vector2) -> Vector2i:
	var x_position: int = (screen_position.x - Constants.ORIGIN.x)/Constants.GRID_PIXEL_WIDTH
	var y_position: int = (screen_position.y - Constants.ORIGIN.y)/Constants.GRID_PIXEL_WIDTH
	return Vector2i(x_position, y_position)

func _on_piece_clicked(piece_id: StringName) -> void:
	print(piece_id)
	_state._board._selected_piece = piece_id
	_refresh_selection_highlight()

func _refresh_selection_highlight() -> void:
	var selected: StringName = _state._board._selected_piece
	for piece_id: StringName in _views:
		var piece_view: PieceContext = _views[piece_id]
		piece_view.set_selected(piece_id == selected)

func _update_game_state() -> void:
	if _state._board.has_escaped(_state._board.get_piece(_state._board._selected_piece)):
		_state._status = Constants.GAME_STATUS.FINISHED
		_game_end_window.visible = true
