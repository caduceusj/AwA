extends Sprite2D
class_name GenericExperiment

@export var experiment_id: int
@export var experiment_name: String

@export var product_list: Array[PackedScene]
var product_instances: Array[GenericProduct]
var product_ids: Array[int]

func _ready():
	instance_products()
	sort_product_ids()
	print(product_instances)

func instance_products() -> void:
	var instance: GenericProduct
	for product in product_list:
		instance = product.instantiate()
		product_instances.append(instance)
		product_ids.append(instance.product_id)
	
func sort_product_ids() -> void:
	if(product_ids.size() > 0):
		product_ids.sort()
