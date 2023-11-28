extends MarginContainer

const menuScene = "res://Scene/MainMenu/MainMenu.tscn"
const startScene = "res://Scene/MainScreen/Lab.tscn"
const optionsScene = "res://Scene/MainMenu/OptionsMenu.tscn"

@onready var selectorOne = $CenterContainer/VBoxContainer/Inputs/VBoxContainer/Start/HBoxContainer/Selector
@onready var selectorTwo = $CenterContainer/VBoxContainer/Inputs/VBoxContainer/Options/HBoxContainer/Selector
@onready var selectorThree = $CenterContainer/VBoxContainer/Inputs/VBoxContainer/Quit/HBoxContainer/Selector

@onready var textOne = $CenterContainer/VBoxContainer/Inputs/VBoxContainer/Start/HBoxContainer/OptionName
@onready var textTwo = $CenterContainer/VBoxContainer/Inputs/VBoxContainer/Options/HBoxContainer/OptionName
@onready var textThree = $CenterContainer/VBoxContainer/Inputs/VBoxContainer/Quit/HBoxContainer/OptionName

const originalFontColor = Color("#ffffff")
const originalShadowColor = Color("#e1eefd")
const selectedFontColor = Color("#65a7f4")
const selectedShadowColor = Color("#2775c8")


var currentSelection = 0

func changeColor(component,fontColor, shadowColor) :
	component.add_theme_color_override("font_color",fontColor)
	component.add_theme_color_override("font_shadow_color",shadowColor)

func setCurrentSelection(currentSelection) :	
	selectorOne.text = ""
	selectorTwo.text = ""
	selectorThree.text = ""
	changeColor(textOne,originalFontColor,originalShadowColor)
	changeColor(textTwo,originalFontColor,originalShadowColor)
	changeColor(textThree,originalFontColor,originalShadowColor)
	if currentSelection == 0 :
		selectorOne.text = ">"
		changeColor(textOne,selectedFontColor,selectedShadowColor)
	elif currentSelection == 1 :
		selectorTwo.text = ">"		
		changeColor(textTwo,selectedFontColor,selectedShadowColor)
	else :
		selectorThree.text = ">"			
		changeColor(textThree,selectedFontColor,selectedShadowColor)


func handleSelection(currentSelection) :
	if(currentSelection == 0) :
		GameManager.current_state = GameManager.state.INTRO
		get_tree().change_scene_to_file(startScene)	
	elif(currentSelection == 1) :
		GameManager.returOptionsScene = menuScene
		get_tree().change_scene_to_file(optionsScene)
	else :
		get_tree().quit()			
		
# Called when the node enters the scene tree for the first time.
func _ready():	
	GameManager.current_state = GameManager.state.INTRO
	
	changeColor(selectorOne,selectedFontColor,selectedShadowColor)
	changeColor(selectorTwo,selectedFontColor,selectedShadowColor)
	changeColor(selectorThree,selectedFontColor,selectedShadowColor)
	setCurrentSelection(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if(Input.is_action_just_pressed("ui_down")) :
		if(currentSelection < 2) :
			currentSelection += 1		
			setCurrentSelection(currentSelection)
		else :
			currentSelection = 0
			setCurrentSelection(currentSelection)
	elif(Input.is_action_just_pressed("ui_up")) :
		if(currentSelection > 0) :
			currentSelection -= 1
			setCurrentSelection(currentSelection)
		else :
			currentSelection = 2
			setCurrentSelection(currentSelection)
	if(Input.is_action_just_pressed("ui_accept")) :
		handleSelection(currentSelection)


func _on_start_mouse_entered():
	currentSelection = 0
	setCurrentSelection(currentSelection) # Replace with function body.


func _on_options_mouse_entered():
	currentSelection = 1
	setCurrentSelection(currentSelection) # Replace with function body.


func _on_quit_mouse_entered():
	currentSelection = 2
	setCurrentSelection(currentSelection) # Replace with function body.



func _on_start_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		handleSelection(0)


func _on_options_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		handleSelection(1) 


func _on_quit_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		handleSelection(2)
