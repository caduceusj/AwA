extends Node2D
#spring current velocity
var velocity = 0

#force being applied to the spring
var force = 0

#current height of the string
var height = 0


var target_height = 0
# Called when the node enters the scene tree for the first time.



func _water_update(spring_constant, dampening):
	height = position.y
	#update the height based on current position
	
	var loss = -dampening * velocity
	
	var x = height - target_height
	#spring current extension
	#hookes law
	force = - spring_constant*x + loss
	#applies force to velocity
	velocity += force
	
	
	
	#make the spring move
	position.y += velocity
	pass

func _initialize(x_position):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position

