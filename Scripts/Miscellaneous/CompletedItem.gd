extends Control

@export var material1 = ""
@export var material2 = ""
@export var material3 = ""
@export var material4 = ""
@export var material5 = ""
@export var experimento = ""
@export var iconeExperimento = ""
@export var idExperimento = 7

@onready var nomeExperimento = $NomeExperimento
	
	
func _process(delta):
	if GameManager.correct_experiments.has(idExperimento):
		$Meteriais/Sprite2D.texture = load(material1)
		$Meteriais/Sprite2D2.texture = load(material2)
		$Meteriais/Sprite2D3.texture = load(material3)
		$Meteriais/Sprite2D4.texture = load(material4)
		$Meteriais/Sprite2D5.texture = load(material5)
		$Moldura/IconeExperimento.texture = load(iconeExperimento)
		$NomeExperimento.text = experimento
