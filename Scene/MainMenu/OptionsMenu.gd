extends MarginContainer

const menuScene = "res://Scene/MainMenu/MainMenu.tscn"

@onready var textOne = $CenterContainer/VBoxContainer/Volume/VBoxContainer/Label
@onready var textTwo = $CenterContainer/VBoxContainer/Return/HBoxContainer/OptionName
@onready var selectorTwo = $CenterContainer/VBoxContainer/Return/HBoxContainer/Selector
@onready var volumeBar = $CenterContainer/VBoxContainer/Volume/VBoxContainer/VolumeBar

const originalFontColor = Color(0.757, 0.737, 0.329)
const originalShadowColor = Color(0.627, 0.506, 0.169)
const selectedFontColor = Color(0.29, 0.435, 0.459)
const selectedShadowColor = Color(0.2, 0.271, 0.373)

var currentSelection = 0


func handleSelection(currentSelection) :
	if(currentSelection == 1) :
		get_tree().change_scene_to_file(menuScene)			
			

func changeColor(component,fontColor, shadowColor) :
	component.add_theme_color_override("font_color",fontColor)
	component.add_theme_color_override("font_shadow_color",shadowColor)

func setCurrentSelection(currentSelection) :	
	selectorTwo.text = ""
	changeColor(textOne,originalFontColor,originalShadowColor)
	changeColor(textTwo,originalFontColor,originalShadowColor)	
	if currentSelection == 0 :		
		changeColor(textOne,selectedFontColor,selectedShadowColor)
	elif currentSelection == 1 :
		selectorTwo.text = ">"		
		changeColor(textTwo,selectedFontColor,selectedShadowColor)	

# Called when the node enters the scene tree for the first time.
func _ready():
	changeColor(selectorTwo,selectedFontColor,selectedShadowColor)	
	setCurrentSelection(0)	

func _process(delta):	
	if(Input.is_action_just_pressed("ui_down")) :
		if(currentSelection < 1) :
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
			currentSelection = 1
			setCurrentSelection(currentSelection)
	if(Input.is_action_just_pressed("ui_accept")) :
		handleSelection(currentSelection)


func _on_volume_mouse_entered():
	currentSelection = 0
	setCurrentSelection(currentSelection)


func _on_return_mouse_entered():
	currentSelection = 1
	setCurrentSelection(currentSelection)


func _on_return_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		get_tree().change_scene_to_file(menuScene)
