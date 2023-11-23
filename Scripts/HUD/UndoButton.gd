extends Button
class_name UndoButton

var is_intro_or_selection_state: bool

func _process(delta):
	is_intro_or_selection_state = GameManager.current_state == GameManager.state.SELECTION || GameManager.current_state == GameManager.state.INTRO

func _on_mouse_entered():
	if(is_intro_or_selection_state):
		set_default_cursor_shape(Control.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	if(is_intro_or_selection_state):
		set_default_cursor_shape(Control.CURSOR_ARROW)
