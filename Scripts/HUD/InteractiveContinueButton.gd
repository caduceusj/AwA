extends Button
class_name ContinueButton

func _on_mouse_entered():
	set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	set_default_cursor_shape(Control.CURSOR_ARROW)
