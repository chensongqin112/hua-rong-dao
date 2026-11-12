class_name PieceState

var _x_position: int = 0
var _y_position: int = 0
var _height: int = 1
var _width: int = 1
var _type: Constants.PIECE_TYPE = Constants.PIECE_TYPE.SMALL
var _id: StringName

func initialize(
		x_position: int,
		y_position: int,
		height: int,
		width: int,
		type: Constants.PIECE_TYPE,
		id: StringName,
	) -> void:
	_x_position = x_position
	_y_position = y_position
	_height = height
	_width = width
	_type = type
	_id = id

func contains_point(x_position: int, y_position: int) -> bool:
	return x_position >= _x_position and y_position >= _y_position and \
	 x_position < (_x_position + _width) and y_position < (_y_position + _height)

func move(direction: Constants.DIRECTION) -> void:
	if direction == Constants.DIRECTION.LEFT:
		_x_position -= 1
	elif direction == Constants.DIRECTION.RIGHT:
		_x_position += 1
	elif direction == Constants.DIRECTION.UP:
		_y_position -= 1
	elif direction == Constants.DIRECTION.DOWN:
		_y_position += 1
