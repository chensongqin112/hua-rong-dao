class_name Constants

static var BOARD_HEIGHT: int = 5
static var BOARD_WIDTH: int = 4
static var MOVE_SPEED: float = 400
static var ORIGIN: Vector2 = Vector2(98,33)
static var LEFT_EDGE: int = 98
static var TOP_EDGE: int = 33
static var GRID_PIXEL_WIDTH: int = 140

enum GAME_STATUS { NOT_STARTED, ACTIVE, PAUSED, FINISHED }
enum PIECE_TYPE { MAIN, SECONDARY, SMALL }
enum DIRECTION { UP, DOWN, LEFT, RIGHT }
