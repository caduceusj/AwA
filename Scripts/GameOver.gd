extends Control

const menuScene = "res://Scene/MainMenu/MainMenu.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_pressed():
	GameManager.correct_experiments.clear()
	get_tree().change_scene_to_file(menuScene)		 # Replace with function body.
