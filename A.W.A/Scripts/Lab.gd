extends Control
var slot0 = false 
var slot1 = false
var slot2 = false

var chemString = ""

var number
# Called when the node enters the scene tree for the first time.
func _ready():
	$fire.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clickSlot(itemname, number):
	print(itemname)
	print(number)
	get_node("itemContainer/slot"+str(number)+"/sprite").texture = load("res://Sprites/individuais/"+str(itemname)+".png")

func check():
	print(chemString)
	$Resultado/Bexiga.hide()
	if(chemString.find("azulDeMetileno") != -1 and chemString.find("iodetoDePotassio") != -1  and chemString.find("aguaOxigenada") != -1):
		print("pasta de dente")
		$Resultado.scale = Vector2(4,4)
		$Resultado.position = Vector2(480,440)
		$Resultado.play("elephantToothpaste")
		await(get_tree().create_timer(3.0).timeout)
		clear()
	if(chemString.find("bexiga") != -1 and chemString.find("vinagre") != -1  and chemString.find("bicarbonatoDeSodio") != -1):
		#432, 488
		$Resultado.scale = Vector2(4,4)
		$Resultado.position = Vector2(432,488)
		$Resultado/Bexiga.show()
		$Resultado.play("garrafaPet")
		$Resultado/Bexiga.play("default")
		await(get_tree().create_timer(3.0).timeout)
		clear()
	if(chemString.find("sodaCaustica") != -1 and chemString.find("azulDeMetileno") != -1 and chemString.find("sodaCaustica")):
		get_tree().change_scene_to_file("res://Scene/fluidSimulation.tscn")
	else:
		clear()

func clear():
	chemString = ""
	slot0 = false
	slot1 = false
	slot2 = false
	get_node("itemContainer/slot0/sprite").texture = null
	get_node("itemContainer/slot1/sprite").texture = null
	get_node("itemContainer/slot2/sprite").texture = null
func check_position(itemname):
	if not slot0:
		number = 0
		slot0 = true
		chemString = itemname + " "
		clickSlot(itemname, number)
	elif not slot1:
		slot1 = true
		number = 1
		chemString = chemString + " " + itemname
		clickSlot(itemname, number)
	elif not slot2:
		slot2 = true
		number = 2
		chemString = chemString + " " + itemname
		clickSlot(itemname, number)
		check()
		
