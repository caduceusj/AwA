extends Node
class_name Experiments

@export var experiments_scenes_list: Array[PackedScene]
@export var product_scenes_list: Array[PackedScene]

var recipe_book: Array[GenericExperiment] = []

var experiment_list: Array[GenericExperiment]
var product_list: Array[GenericProduct]

func instance_experiments() -> void:
	experiment_list.clear()
	var experiment_instance: GenericExperiment
	for experiment in experiments_scenes_list:
		experiment_instance = experiment.instantiate()
		experiment_list.append(experiment_instance)

func instance_products() -> void:
	product_list.clear()
	var product_instance: GenericProduct
	for product in product_scenes_list:
		product_instance = product.instantiate()
		product_list.append(product_instance)

func _ready():
	instance_experiments()
	instance_products()
