class_name BoardBackgroundContext extends CharacterBody2D

signal board_clicked(mouse_position: Vector2)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		print("Board background position: " + str(get_global_mouse_position()))
		board_clicked.emit(get_global_mouse_position())
