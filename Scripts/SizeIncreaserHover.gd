extends Node
class_name ChemicalProduct

@export var id: int = -1

@onready var button = $ButtonPrefab
@onready var scaleObject = get_node(".")

var original_scale : Vector2
var target_scale : Vector2 = Vector2(4, 4)
var speed : float = 1.0

var game_controller: GameController

func _ready():
	original_scale = scaleObject.scale
	button.pressed.connect(self._on_button_prefab_pressed)
	game_controller = get_parent().get_parent()

func _on_button_prefab_mouse_entered():
	if(GameManager.current_state == GameManager.state.SELECTION):
		scaleObject.scale = scaleObject.scale.lerp(target_scale, speed)
		button.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
		
func _on_button_prefab_mouse_exited():
	if(GameManager.current_state == GameManager.state.SELECTION):
		scaleObject.scale = scaleObject.scale.lerp(original_scale, speed)
		button.set_default_cursor_shape(Control.CURSOR_ARROW)

func _on_button_prefab_pressed():
	if(GameManager.current_state == GameManager.state.SELECTION):
		game_controller.select_product(id)
