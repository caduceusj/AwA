extends AnimatedSprite2D
class_name GenericExperiment

@export var experiment_id: int
@export var experiment_name: String

@export var product_list: Array[PackedScene]
var product_instances: Array[GenericProduct]
var product_ids: Array[int]

@export var is_interactive: bool
@export var interaction: PackedScene

@onready var audio = $AudioStreamPlayer

var is_animation_finished: bool = false

func _ready():
	instance_products()
	sort_product_ids()

func instance_products() -> void:
	var instance: GenericProduct
	for product in product_list:
		instance = product.instantiate()
		product_instances.append(instance)
		product_ids.append(instance.product_id)
	
func sort_product_ids() -> void:
	if(product_ids.size() > 0):
		product_ids.sort()


func run_animation() -> void:
	if(!is_interactive):
		play("run_experiment")
		audio.play()
	else:
		get_tree().change_scene_to_packed(interaction)


func _on_animation_finished():
	print("ACABOU")
	is_animation_finished = true
