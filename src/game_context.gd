class_name GameContext extends Node

signal on_game_loss

# PACKED SCENES
@export var shape_library_packed: PackedScene
@export var camera_packed: PackedScene

var _game_state_holder: GameStateHolder

func build_services() -> void:
	return

func bind_services(gsh: GameStateHolder) -> void:
	_game_state_holder = gsh

func handle_start_new_game() -> void:
	_game_state_holder.game_state = GameState.new()
	_game_state_holder.game_state.initialize()
	
