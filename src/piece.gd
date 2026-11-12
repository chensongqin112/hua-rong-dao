class_name PieceContext extends CharacterBody2D

signal clicked(piece_id: StringName)
@export var piece_id: StringName
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	input_pickable = true
	add_to_group("pieces")
	target_position = Vector2.ZERO

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(piece_id)

func sync_from_state(state: PieceState) -> void:
	print("New PieceState: " + str(state._x_position) + ", " + str(state._y_position))
	target_position = Constants.ORIGIN + Vector2(state._x_position, state._y_position) * Vector2(140,140) + \
		Vector2(state._width*70, state._height*70)
	print("Current Position: " + str(position.x) + ", " + str(position.y))
	#print("Target Position: " + str(target_position.x) + ", " + str(target_position.y))

func set_selected(is_selected: bool) -> void:
	modulate = Color(1.25, 1.15, 0.7) if is_selected else Color.WHITE

func _physics_process(delta: float) -> void:
	if position.distance_to(target_position) < 1.0:
		position = target_position
		velocity = Vector2.ZERO
		return

	position = position.move_toward(target_position, Constants.MOVE_SPEED * delta)
