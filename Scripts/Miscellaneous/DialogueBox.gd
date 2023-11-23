extends TextureRect
class_name DialogueBox

@onready var name_text = $Name
@onready var text = $Text
@onready var indicator = $Indicator
@onready var indicator_animation_player = $Indicator/AnimationPlayer
@onready var timer = $Timer

@export var dialogue_path: String = ""
@export var text_speed: float = 0.05

var dialog: Array 

var phrase_num: int = 0
var finished = false

func _ready():
	timer.wait_time = text_speed
	dialog = get_dialog()
	assert(dialog, "Dialogue not found")
	next_phrase()
	
func _process(delta):
	indicator.set_visible(finished)
	indicator_animation_player.play("moving")

func handle_next_button() -> bool:
	if(finished):
		return await next_phrase()
	else:
		text.visible_characters = len(text.text)
		return true

func get_dialog() -> Array:
	assert(FileAccess.file_exists(dialogue_path), "File path does not exist")
	var f: FileAccess = FileAccess.open(dialogue_path, FileAccess.READ)
	
	var json: String = f.get_as_text()
	
	var output = JSON.parse_string(json)
	
	if(typeof(output) == TYPE_ARRAY):
		return output
	else:
		return []

func next_phrase() -> bool:
	if(phrase_num >= len(dialog)):
#		queue_free()
		return false
	
	finished = false
	
	name_text.text = dialog[phrase_num]["Name"]
	text.text = dialog[phrase_num]["Text"]
	
	text.visible_characters = 0
	while text.visible_characters < len(text.text):
		text.visible_characters += 1
		
		timer.start()
		await timer.timeout
	
	finished = true
	phrase_num += 1
	return true
