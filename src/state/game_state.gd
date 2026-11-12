class_name GameState

var _status: Constants.GAME_STATUS = Constants.GAME_STATUS.NOT_STARTED
var _last_status:  Constants.GAME_STATUS =  Constants.GAME_STATUS.NOT_STARTED
var _moves: int
var _board: BoardState

func initialize() -> void:
	_moves = 0
	_board = BoardState.new()
	_board.initialize()
	_board.initialize_layout()
