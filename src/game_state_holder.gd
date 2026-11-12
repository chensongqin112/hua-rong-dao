class_name GameStateHolder extends Node

var _game_state: GameState

func get_state() -> GameState:
	return _game_state

func initialize() -> void:
	_game_state = GameState.new()
	_game_state.initialize()

func clear() -> void:
	_game_state = null
