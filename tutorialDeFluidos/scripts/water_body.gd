extends Node2D

@export var k = 0.015
@export var d = 0.5
@export var spread = 0.0004
@export var distance_between_springs = 32
#number of instances
@export var springNumber = 8
#water depth
@export var depth = 1000
var current_color
var t 

var target_height = global_position.y
var bottom = target_height + depth

@onready var water_polygon = $Water_Polygon
@onready var audio = $AudioStreamPlayer
@onready var audioBackground = $AudioStreamPlayer2
@onready var water_spring = preload("res://tutorialDeFluidos/scenes/water_spring.tscn")

@onready var waterMaterial = water_polygon.material

var passes = 6
var springs = []

# Adicione estas variáveis para controlar a interpolação de cores
var start_color = Color(0, 0.25, 1, 0.1) # Azul transparente
var end_color = Color(0, 0.25, 1, 0.75) # Azul escuro
var duration = 5.0 # Duração da interpolação em segundos
var elapsed = 0.0 # Tempo decorrido

func _ready():
	audioBackground.play()
	for i in springNumber:
		var x_position = distance_between_springs * i 
		var w = water_spring.instantiate()
		
		add_child(w)
		springs.append(w)
		w._initialize(x_position)

func _physics_process(delta):
	elapsed += delta # Atualiza o tempo decorrido
	
	for i in springs:
		i._water_update(k,d)
	
	var left_deltas = []
	var right_deltas = []
	
	for i in springs.size():
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in passes:
		for i in springs.size():
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	# Atualize o tempo decorrido
	elapsed += delta
	# Calcule a proporção do tempo decorrido em relação à duração total
	t = min(elapsed / duration, 1.0)
	# Interpole a cor usando a proporção
	var current_color = end_color.lerp(start_color, t)

	# Aplique a cor interpolada ao shader
	waterMaterial.set_shader_parameter("water_tint", current_color)
	draw_water_body()

func splash(index, speed):
	var current_color = start_color.lerp(end_color, t)
	if index>0 and index <springs.size():
		springs[index-1].velocity += speed
		springs[index].velocity += speed
		springs[index+1].velocity += speed
		# Inicia a interpolação de cores quando a função splash é chamada
		elapsed = 0.0
		
func _input(event):
	if(event.is_action_pressed("ui_accept") or event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		splash(randi_range(1,23),10)
		audio.play()
		

func draw_water_body():
	var surface_points = []
	for i in springs.size():
		surface_points.append(springs[i].position)
	var spline = Curve2D.new()
	for point in surface_points:
		spline.add_point(point)

	var water_polygon_points = spline.get_baked_points()

	water_polygon_points.append(Vector2(surface_points[-1].x, bottom))
	water_polygon_points.append(Vector2(surface_points[0].x , bottom))
	
	water_polygon_points = PackedVector2Array(water_polygon_points)
	water_polygon.set_polygon(water_polygon_points)
	# Atualiza a cor do polígono da água com base na interpolação de cores
	var t = min(elapsed / duration, 1.0) # Normaliza o tempo decorrido para o intervalo [0, 1]
	var current_color = end_color.lerp(start_color, t) # Interpola para a cor final
	
	if t < 1.0:
		water_polygon.modulate = current_color # Aplica a cor interpolada ao polígono da água
	else:
		water_polygon.modulate = start_color # Retorna à cor inicial após a interpolação

