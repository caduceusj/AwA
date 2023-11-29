extends Control
class_name GameController

@onready var pause = $MarginContainer

const gameOver = "res://Scene/MainScreen/GameOver.tscn"

@export var experiments_list: Array[PackedScene]
var experiments_instances: Array[GenericExperiment]

var selected_products: Array[GenericProduct]
var correct_products: Array[GenericProduct]
var all_correct_products: Array[GenericProduct]

var correct_experiment: GenericExperiment

@onready var scientist_animation_player: AnimationPlayer = $Cientista/AnimationPlayer
@onready var combine_button: Button = $CombineButton
@onready var board_button: Button = $QuadroBotao
@onready var text_field: TextureButton = $DicaUi
@onready var text_field_label: Label = $DicaUi/Label
@onready var backgroundMusic =  $AudioStreamPlayer

var audio1 = preload("res://assets/Audios/InGame/AWA1.wav")
var audio2 = preload("res://assets/Audios/InGame/AWA2.wav")
var audio3 = preload("res://assets/Audios/InGame/AWA3.wav")
var audio4 = preload("res://assets/Audios/InGame/AWA4.wav")

var dialogue: PackedScene = preload("res://Scene/Miscellaneous/DialogueBox.tscn")
var dialogue_instance: DialogueBox = null

var is_last_message: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ExperimentsManagerGlobal.instance_experiments()
	ExperimentsManagerGlobal.instance_products()
	
	$products/Fire/AnimationPlayer.play("light_on")
	$DicaUi.visible = false
	$Book.visible = false
	pause.visible = false
	
	if(GameManager.current_state == GameManager.state.INTRO):
		scientist_animation_player.play("Walking_in")
		combine_button.set_disabled(true)
		board_button.set_disabled(true)
		

func instance_experiments() -> void:
	var instance: GenericExperiment
	for experiment in ExperimentsManagerGlobal.experiment_list:
		$Experiment.add_child(experiment)
		experiments_instances.append(experiment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(GameManager.current_state == GameManager.state.INTRO):
		if(Input.is_action_just_pressed("ui_accept") && dialogue_instance != null):
			var dialogue_ended: bool = !(await dialogue_instance.handle_next_button())
			if(dialogue_ended):
				handle_dialogue_end()
	elif(GameManager.current_state == GameManager.state.LOAD):
		if(experiments_instances.is_empty()) : 
			instance_experiments()
			GameManager.current_state = GameManager.state.SELECTION
	elif(GameManager.current_state == GameManager.state.SELECTION):
		if(GameManager.correct_experiments.size() == 6):
			await(get_tree().create_timer(3.0).timeout)
			get_tree().change_scene_to_file(gameOver)
	elif(GameManager.current_state == GameManager.state.RESULT):
		pass
	elif(GameManager.current_state == GameManager.state.POST_RESULT):
		if(GameManager.correct_experiments.size() == 6):
			await(get_tree().create_timer(3.0).timeout)
			get_tree().change_scene_to_file(gameOver)
		else:
			GameManager.current_state = GameManager.state.SELECTION

func handle_dialogue_end() -> void:
	dialogue_instance.queue_free()
	scientist_animation_player.play("Walking_out")
	combine_button.set_disabled(true)

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
					if(correct_products.find(selected_product) == -1):
						correct_products.append(selected_product)
					all_correct_products.append(selected_product)
					break
			if(!is_product_in_list):
				has_wrong_product = true
# 		Mark receipt_book the corrects products
		if(!has_wrong_product && experiment.product_instances.size() == selected_products.size()):
#			Mark receipt_book the correct experiment
			correct_experiment = experiment
			if(GameManager.correct_experiments.find(correct_experiment.experiment_id) == -1):
				GameManager.correct_experiments.append(correct_experiment.experiment_id)
			is_valid = true
		correct_products.clear()

	return is_valid
	
func run_experiment() -> void:
	GameManager.current_state = GameManager.state.RESULT
	showDicaUi(correct_experiment.experiment_name)
	correct_experiment.visible = true
	correct_experiment.run_animation()
	await(get_tree().create_timer(4.0).timeout)
	GameManager.current_state = GameManager.state.POST_RESULT
	correct_experiment.visible = false
	clear()
	

func _on_dica_ui_timer_timeout():
	$DicaUi.visible = false

func _on_combine_button_pressed():
	if(GameManager.current_state == GameManager.state.INTRO):
		var dialogue_ended: bool = !(await dialogue_instance.handle_next_button())
		if(dialogue_ended):
			handle_dialogue_end()
	elif(GameManager.current_state == GameManager.state.SELECTION):
		if(is_reaction_valid()):
			run_experiment()
			var count = GameManager.correct_experiments.size()
			if(count > 5) : backgroundMusic.stream = audio4
			elif(count > 3) : backgroundMusic.stream = audio3
			elif(count > 1) : backgroundMusic.stream = audio2
			backgroundMusic.play()
		else:
			print(correct_products)
			if(correct_products.size() > 1):
				var names: String = ""
				
				var count: int = 0
				for product in correct_products:
					count += 1
					names += product.product_name
					if (count != correct_products.size()):
						names += ", "
				showDicaUi("Os " + names + " parecem ter combinado. \n Continue combinando.")
			else:
				showDicaUi("Nenhum experimento realizado. \n Tente Novamente.")
			clear()

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "Walking_in"):
		combine_button.set_disabled(false)
		board_button.set_disabled(false)
		dialogue_instance = dialogue.instantiate()
		dialogue_instance.dialogue_path = "res://assets/Dialogues/Scientist_Intro.json"
		dialogue_instance.text_speed = 0.03
		add_child(dialogue_instance)
	if(anim_name == "Walking_out"):
		combine_button.set_disabled(false)
		board_button.set_disabled(false)
		GameManager.current_state = GameManager.state.LOAD


func _on_undo_button_pressed():
	if(GameManager.current_state == GameManager.state.SELECTION):
		clear()

func _on_combine_button_2_gui_input(event):
	if(GameManager.current_state == GameManager.state.SELECTION):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
			pause.visible = true

func _on_livro_botao_pressed():
	if(GameManager.current_state == GameManager.state.SELECTION):	
		$Book.visible = true
		pause.visible = true
		pause.get_child(1).visible = false
		$products/Fire.visible = false

func _on_button_pressed():
	pause.get_child(1).visible = true
	$Book.visible = false
	pause.visible = false
	$products/Fire.visible = true
