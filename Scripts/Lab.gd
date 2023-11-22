extends Control
class_name GameController

@export var experiments_list: Array[PackedScene]
var experiments_instances: Array[GenericExperiment]

var selected_products: Array[GenericProduct]
var correct_products: Array[GenericProduct]
var all_correct_products: Array[GenericProduct]

var correct_experiment: GenericExperiment

@onready var scientist_animation_player: AnimationPlayer = $Cientista/AnimationPlayer
@onready var combine_button: Button = $CombineButton
@onready var text_field: TextureButton = $DicaUi
@onready var text_field_label: Label = $DicaUi/Label

var is_last_message: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$fire.play("default")
	$DicaUi.visible = false
	instance_experiments()
	
	if(GameManager.current_state == GameManager.state.INTRO):
		scientist_animation_player.play("Walking_in")
		combine_button.set_disabled(true)


func instance_experiments() -> void:
	var instance: GenericExperiment
	for experiment in ExperimentsManagerGlobal.experiment_list:
		$Experiment.add_child(experiment)
		experiments_instances.append(experiment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(GameManager.current_state == GameManager.state.INTRO):
		pass
	elif(GameManager.current_state == GameManager.state.SELECTION):
		pass
	elif(GameManager.current_state == GameManager.state.RESULT):
		pass
	elif(GameManager.current_state == GameManager.state.POST_RESULT):
		pass

func update_slots() -> void:
	for slot_position in selected_products.size():
		get_node("itemContainer/slot"+str(slot_position)+"/sprite").texture = selected_products[slot_position]

func clickSlot(itemname: String, texture: Texture2D, slot: int):
	get_node("itemContainer/slot"+str(slot)+"/sprite").texture = texture

func clear():
	correct_experiment = null
	update_slots()
	selected_products = []

func showDicaUi(text):
	$DicaUi.visible = true
	$DicaUi/Label.text = text
	$DicaUITimer.start()

func select_product(product_id: int) -> void:
	if(selected_products.size() < GameManager.PRODUCTS_SELECT_LIMIT):
		for prod in ExperimentsManagerGlobal.product_list:
			if(prod.product_id == product_id):
				selected_products.append(prod)
				clickSlot(prod.product_name, prod.texture, selected_products.size()-1)
				break
	else:
		pass #Warn
	
func is_reaction_valid() -> bool:
	var is_valid: bool = false
	for experiment in ExperimentsManagerGlobal.experiment_list:
		var has_wrong_product: bool = false
		for selected_product in selected_products:
			var is_product_in_list: bool = false
			for experiment_product in experiment.product_instances:
				if(selected_product.product_id == experiment_product.product_id):
					is_product_in_list = true
					correct_products.append(selected_product)
					all_correct_products.append(selected_product)
					break
			if(!is_product_in_list):
				has_wrong_product = true
# 		Mark receipt_book the corrects products
		if(!has_wrong_product && experiment.product_instances.size() == selected_products.size()):
#			Mark receipt_book the correct experiment
			correct_experiment = experiment
			is_valid = true
		correct_products.clear() # Melhorar clear

	return is_valid
	
func run_experiment() -> void:
	GameManager.current_state = GameManager.state.RESULT
	showDicaUi(correct_experiment.experiment_name)
	correct_experiment.visible = true
	correct_experiment.run_animation()
	await(get_tree().create_timer(3.0).timeout)
	GameManager.current_state = GameManager.state.SELECTION
	correct_experiment.visible = false
	clear()

func _on_dica_ui_timer_timeout():
	$DicaUi.visible = false

func _on_combine_button_pressed():
	if(GameManager.current_state == GameManager.state.INTRO):
		if(!is_last_message):
			text_field_label.set_text("Clique neles e depois clique em combinar para descobrir se você acertou. Boa sorte!")
			is_last_message = true
		else:
			text_field_label.set_text("Até mais, meu aprendiz")
			scientist_animation_player.play("Walking_out")
			combine_button.set_disabled(true)
	elif(GameManager.current_state == GameManager.state.SELECTION):
		if(is_reaction_valid()):
			run_experiment()
		else:
			showDicaUi("Nenhum experimento realizado. \n Tente Novamente.")
			clear()

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "Walking_in"):
		combine_button.set_disabled(false)
		text_field.set_visible(true)
		text_field_label.set_text("Olá jovem cientista, o desafio de hoje será descobrir todos os experimentos possíveis com o produtos ao lado")
	if(anim_name == "Walking_out"):
		text_field.set_visible(false)
		combine_button.set_disabled(false)
		GameManager.current_state = GameManager.state.SELECTION
