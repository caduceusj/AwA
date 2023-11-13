extends Control
class_name GameController

@export var experiments_list: Array[PackedScene]
var experiments_instances: Array[GenericExperiment]

var selected_products: Array[GenericProduct]
var correct_products: Array[GenericProduct]
var all_correct_products: Array[GenericProduct]

var correct_experiment: GenericExperiment

var number
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$fire.play("default")
	$DicaUi.visible = false
	instance_experiments()
	

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
	for count in selected_products.size():
		get_node("itemContainer/slot"+str(count)+"/sprite").texture = selected_products[count]

func clickSlot(itemname: String, texture: Texture2D, slot: int):
	get_node("itemContainer/slot"+str(slot)+"/sprite").texture = texture

func clear():
	correct_experiment = null
	update_slots()
	selected_products = []
#	get_node("itemContainer/slot0/sprite").texture = null
#	get_node("itemContainer/slot1/sprite").texture = null
#	get_node("itemContainer/slot2/sprite").texture = null
	

func showDicaUi(text):
	$DicaUi.visible = true
	$DicaUi/Label.text = text
	$DicaUITimer.start()

#func check():
#	print(chemString)
#	$Resultado/Bexiga.hide()
#	if(chemString.find("azulDeMetileno") != -1 and chemString.find("iodetoDePotassio") != -1  and chemString.find("aguaOxigenada") != -1):
#		print("pasta de dente")
#		showDicaUi("Pasta de Dente de Elefante")
#		$Resultado.scale = Vector2(4,4)
#		$Resultado.position = Vector2(480,440)
#		$Resultado.play("elephantToothpaste")
#		await(get_tree().create_timer(3.0).timeout)
#		clear()
#	elif(chemString.find("bexiga") != -1 and chemString.find("vinagre") != -1  and chemString.find("bicarbonatoDeSodio") != -1):
#		#432, 488
#		showDicaUi("Bexiga cheia!")
#		$Resultado.scale = Vector2(4,4)
#		$Resultado.position = Vector2(432,488)
#		$Resultado/Bexiga.show()
#		$Resultado.play("garrafaPet")
#		$Resultado/Bexiga.play("default")
#		await(get_tree().create_timer(3.0).timeout)
#		clear()
#
#	elif(chemString.find("agua") != -1 and chemString.find("sodaCaustica") != -1  and chemString.find("vinagre") != -1):
#		#432, 488
#		showDicaUi("Gelo Quente!")
##		$Resultado.scale = Vector2(4,4)
##		$Resultado.position = Vector2(432,488)
##		$Resultado/Bexiga.show()
##		$Resultado.play("garrafaPet")
##		$Resultado/Bexiga.play("default")
#		await(get_tree().create_timer(3.0).timeout)
#		clear()
#
#	elif(chemString.find("sodaCaustica") != -1 and chemString.find("azulDeMetileno") != -1 and chemString.find("sodaCaustica")):
#		get_tree().change_scene_to_file("res://Scene/fluidSimulation.tscn")
##		showDicaUi("Água Furiosa")
#	else:
#		showDicaUi("Nenhum experimento realizado. \n Tente Novamente.")
#		clear()

func select_product(product_id: int) -> void:
#	print("A1")
	if(selected_products.size() < GameManager.PRODUCTS_SELECT_LIMIT):
#		print("A2")
		for prod in ExperimentsManagerGlobal.product_list:
#			print("A3")
			if(prod.product_id == product_id):
#				print("A4")
				selected_products.append(prod)
				clickSlot(prod.product_name, prod.texture, selected_products.size()-1)
				break
	else:
		pass #Warn
	
#	if not slot0:
#		number = 0
#		slot0 = true
#		chemString = itemname + " "
#		clickSlot(itemname, number)
#	elif not slot1:
#		slot1 = true
#		number = 1
#		chemString = chemString + " " + itemname
#		clickSlot(itemname, number)
#	elif not slot2:
#		slot2 = true
#		number = 2
#		chemString = chemString + " " + itemname
#		clickSlot(itemname, number)
#		check()

func is_reaction_valid() -> bool:
	var is_valid: bool = false
	for experiment in ExperimentsManagerGlobal.experiment_list:
		print("A1")
		print(experiment.experiment_name)
		for experiment_product in experiment.product_instances:
			print("A2")
			print(experiment_product.product_name)
			for selected_product in selected_products:
				if(selected_product.product_id == experiment_product.product_id):
					correct_products.append(selected_product)
					all_correct_products.append(selected_product)
					break
# 		Mark receipt_book the corrects products
		print(experiment.product_instances.size())
		if(experiment.product_instances.size() == correct_products.size()):
#			Mark receipt_book the correct experiment
			correct_experiment = experiment
			is_valid = true
		correct_products.clear() # Melhorar clear

	return is_valid
	
func run_experiment() -> void:
	GameManager.current_state = GameManager.state.RESULT
	showDicaUi(correct_experiment.experiment_name)
	correct_experiment.visible = true
#	$Resultado.play("elephantToothpaste")
	await(get_tree().create_timer(3.0).timeout)
	GameManager.current_state = GameManager.state.SELECTION
	correct_experiment.visible = false
	clear()

func _on_dica_ui_timer_timeout():
	$DicaUi.visible = false

func _on_combine_button_pressed():
	if(GameManager.current_state == GameManager.state.SELECTION):
		if(is_reaction_valid()):
			run_experiment()
		else:
			showDicaUi("Nenhum experimento realizado. \n Tente Novamente.")
			clear()
