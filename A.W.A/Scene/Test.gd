extends Control

var emptyBottom = false
var emptyMiddle = false

var fire = false

var colorBottom = ""
var colorMiddle = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_orange_dust_pressed():
	if(emptyBottom == false):
		emptyBottom = true
		$emptyBottom.color = Color(255,255,0,255)
		colorBottom = "IODETO DE POTASSIO"
	elif(emptyMiddle == false):
		emptyMiddle = true
		$emptyMiddle.color = Color(255,255,0,255)
		colorMiddle = "IODETO DE POTASSIO"
		
func _on_green_dust_pressed():
	if(emptyBottom == false):
		emptyBottom = true
		$emptyBottom.color = Color(0,255,0,255)
		colorBottom = "SODA CAUSTICA"
	elif(emptyMiddle == false):
		emptyMiddle = true
		$emptyMiddle.color = Color(0,255,0,255)
		colorMiddle = "SODA CAUSTICA"


func _on_purple_dust_pressed():
	if(emptyBottom == false):
		emptyBottom = true
		$emptyBottom.color = Color(255,0,255,255)
		colorBottom = "GLICOSE"
	elif(emptyMiddle == false):
		emptyMiddle = true
		$emptyMiddle.color = Color(255,0,255,255)
		colorMiddle = "GLICOSE"



func _on_blue_dust_pressed():
	if(emptyBottom == false):
		emptyBottom = true
		$emptyBottom.color = Color(0,0,255,255)
		colorBottom = "BLUE"
	elif(emptyMiddle == false):
		emptyMiddle = true
		$emptyMiddle.color = Color(0,0,255,255)
		colorMiddle = "BLUE"

func _on_clear_pressed():
	emptyBottom = false
	emptyMiddle = false
	colorBottom = ""
	colorBottom = ""
	$emptyBottom.color = Color(255,255,255,255)
	$emptyMiddle.color = Color(255,255,255,255)
	$Result.text = "Resultado Aqui"

func _on_mix_pressed():
	if(colorBottom == "IODETO DE POTASSIO" && colorMiddle == "H2O2" or colorBottom == "H2O2" && colorMiddle == "IODETO DE POTASSIO"):
		$Result.text = "Pasta de Dente de Elefante"
		
	if(colorBottom == "SODA CAUSTICA" && colorMiddle == "GLICOSE" or colorBottom == "GLICOSE" && colorMiddle == "SODA CAUSTICA"):
		$Result.text = "Água Furiosa"
		get_tree().change_scene_to_file("res://Scene/fluidSimulation.tscn")


func _on_fogão_pressed():
	if(fire == false):
		fire = true
		$fire.color = Color(250,100,0,255)
		$fogoLabel.show()
	else:
		fire = false
		$fire.color = Color(92,95,99,255)
		$fogoLabel.hide()




func _on_h_2o_2_pressed():
	if(emptyBottom == false):
		print("pORRA")
		emptyBottom = true
		$emptyBottom.color = Color(0.411765, 0.411765, 0.411765, 1)
		colorBottom = "H2O2"
	elif(emptyMiddle == false):
		print("CARALHO")
		emptyMiddle = true
		$emptyMiddle.color = Color(0.411765, 0.411765, 0.411765, 1)
		colorMiddle = "H2O2"
