extends Button

func _on_mouse_entered():
	if(GameManager.current_state == GameManager.state.SELECTION):
		set_default_cursor_shape(Control.CURSOR_POINTING_HAND)


func _on_mouse_exited():
	if(GameManager.current_state == GameManager.state.SELECTION):
		set_default_cursor_shape(Control.CURSOR_ARROW)
