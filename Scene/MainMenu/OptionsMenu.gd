extends MarginContainer

@onready var textOne = $CenterContainer/VBoxContainer/Volume/VBoxContainer/Label
@onready var textTwo = $CenterContainer/VBoxContainer/Return/HBoxContainer/OptionName
@onready var selectorTwo = $CenterContainer/VBoxContainer/Return/HBoxContainer/Selector
@onready var volumeBar = $CenterContainer/VBoxContainer/Volume/VBoxContainer/VolumeBar

const originalFontColor = Color("#083040")
const originalShadowColor = Color("#142e4001")
const selectedFontColor = Color("#411808")
const selectedShadowColor = Color("#400814")

var currentSelection = 0


func handleSelection(currentSelection) :
	if(currentSelection == 1) :
		get_tree().change_scene_to_file(GameManager.returOptionsScene)			
			

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
	pass

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
		get_tree().change_scene_to_file(GameManager.returOptionsScene)


func _on_volume_bar_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)
	if value == -30 :
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),true)
	else : 
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),false)
