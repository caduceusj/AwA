extends MarginContainer

const labScene = "res://Scene/MainScreen/Lab.tscn"
const optionsMenu = "res://Scene/MainMenu/OptionsMenu.tscn"
const menuScene = "res://Scene/MainMenu/MainMenu.tscn"


@onready var this = $"."

var currentSelection = 0

func handleSelection(currentSelection) :
	if(currentSelection == 0) :
		this.visible = false
	elif(currentSelection == 1) :
		GameManager.returOptionsScene = labScene
		get_tree().change_scene_to_file(optionsMenu)
	elif(currentSelection == 2) :		
		GameManager.correct_experiments.clear()
		get_tree().change_scene_to_file(menuScene)			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_down")) :
		if(currentSelection < 1) :
			currentSelection += 1					
		else :
			currentSelection = 0			
	elif(Input.is_action_just_pressed("ui_up")) :
		if(currentSelection > 0) :
			currentSelection -= 1
		else :
			currentSelection = 1			
	if(Input.is_action_just_pressed("ui_accept")) :
		handleSelection(currentSelection)
	

func _on_combine_button_mouse_entered(argument) -> void:
	set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
	currentSelection = argument
			
func _on_combine_button_mouse_exited():	
	set_default_cursor_shape(Control.CURSOR_ARROW)
	
func _on_button_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		handleSelection(currentSelection)# Replace with function body.
