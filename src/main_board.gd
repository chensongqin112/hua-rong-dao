class_name MainBoardContext extends Node2D

signal request_end_game

var _game_state_holder: GameStateHolder
var _game_controller: GameController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func build_services() -> void:
	_game_controller = GameController.new()
	add_child(_game_controller)

func bind_services(gsh: GameStateHolder) -> void:
	_game_state_holder = gsh
	_game_controller.bind_services(gsh)
	_bind_board()
	_bind_pieces()
	_bind_ui()

func connect_signals() -> void:
	%EndGameButton.pressed.connect(handle_end_game)
	%UndoButton.pressed.connect(_game_controller.undo_move)
	%RedoButton.pressed.connect(_game_controller.redo_move)
	return

func _bind_board() -> void:
	var board_background:BoardBackgroundContext = get_node("BoardBackground")
	_game_controller.bind_board(board_background)

func _bind_pieces() -> void:
	for piece_view: PieceContext in get_tree().get_nodes_in_group("pieces"):
		_game_controller.bind_piece(piece_view)

func _bind_ui() -> void:
	var moves_label:Label = get_node("Control/NumMovesLabel")
	_game_controller.bind_ui(moves_label, %GameEndWindow)

func handle_start_game() -> void:
	_game_controller.start()

func handle_end_game() -> void:
	request_end_game.emit()
