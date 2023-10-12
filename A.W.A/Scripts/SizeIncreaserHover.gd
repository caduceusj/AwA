extends Node


var original_scale : Vector2
var target_scale : Vector2 = Vector2(4, 4)
var speed : float = 1.0
@onready var button = $ButtonPrefab
@onready var scaleObject = get_node(".")

func _ready():
	
	original_scale = scaleObject.scale
	button.pressed.connect(self._on_button_prefab_pressed)


func _on_button_prefab_mouse_entered():
	scaleObject.scale = scaleObject.scale.lerp(target_scale, speed)


func _on_button_prefab_mouse_exited():
	scaleObject.scale = scaleObject.scale.lerp(original_scale, speed)


func _on_button_prefab_pressed():
	get_parent().check_position(name)
