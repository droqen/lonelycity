extends Camera2D

var m : Vector2
var mgrab : bool = false
func _physics_process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not mgrab:
			mgrab = true
			m = get_global_mouse_position() - position
		else:
			var m2 = get_global_mouse_position() - position
			position -= m2 - m
			m = m2
	else:
		mgrab = false
