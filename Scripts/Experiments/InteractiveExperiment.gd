extends Node2D
class_name InteractiveExperiment

const startScene: String = "res://Scene/MainScreen/Lab.tscn"

func _on_continue_button_pressed():
	GameManager.current_state = GameManager.state.LOAD
	get_tree().change_scene_to_file(startScene)
