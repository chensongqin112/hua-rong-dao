class_name RootContext extends Node

@export var main_menu_packed: PackedScene
@export var main_board_packed: PackedScene

var _game_state_holder: GameStateHolder

var current_scene: Node

func _ready() -> void:
	build_services()
	bind_services()
	go_to_menu()

func build_services() -> void:
	_game_state_holder = GameStateHolder.new()
	_game_state_holder.initialize()
	add_child(_game_state_holder)
	
func bind_services() -> void:
	return

func go_to_menu() -> void:
	if current_scene:
		current_scene.queue_free()
	current_scene = main_menu_packed.instantiate()
	add_child(current_scene)

	var menu_scene: MenuContext = current_scene as MenuContext
	if menu_scene:
		menu_scene.build_services()
		menu_scene.bind_services(_game_state_holder)
		menu_scene.connect_signals()
		menu_scene.setup()
		
		menu_scene.request_quit.connect(handle_request_quit)
		menu_scene.request_start_game.connect(handle_request_start_game)
	
func handle_request_start_game() -> void:
	if current_scene:
		current_scene.queue_free()
	current_scene = main_board_packed.instantiate()
	add_child(current_scene)

	var main_board: MainBoardContext = current_scene as MainBoardContext
	if main_board:
		main_board.build_services()
		main_board.bind_services(_game_state_holder)
		main_board.connect_signals()
		main_board.handle_start_game()

		main_board.request_end_game.connect(handle_end_game)

func handle_request_quit() -> void:
	get_tree().quit()
	
func handle_end_game() -> void:
	_game_state_holder.initialize()
	go_to_menu()
