class_name MenuContext extends Node

signal request_quit
signal request_start_game

@export var camera_packed: PackedScene

var _game_state_holder: GameStateHolder

func build_services() -> void:
	return

func bind_services(gsh: GameStateHolder) -> void:
	_game_state_holder = gsh

func setup() -> void:
	return

func connect_signals() -> void:
	%StartGameButton.pressed.connect(on_request_start_game)
	%ExitGameButton.pressed.connect(on_request_quit)
	return

func handle_dismiss_loss() -> void:
	_game_state_holder.clear()
	
func on_request_start_game() -> void:
	request_start_game.emit()
	
func on_request_quit() -> void:
	request_quit.emit()
