extends CharacterBody2D
class_name Unit

var speech_bubble

var text_delta: float = 0.0
var text_delay: float = 0.0
var text_queue: Array

func _ready():
	var speech_bubble_path = "res://Scenes/Units/speech_bubble.tscn"
	var new = await load(speech_bubble_path).instantiate()
	new.visible = false
	new.direction = "Center"
	add_child(new)
	speech_bubble = new

func show_speech_bubble(text, delay: float = 2.0, vertical_offset: float = -32):
	if text is String:
		text_queue = [text]
	else:
		text_queue = text
	
	text_delta = 0.0
	text_delay = delay
	speech_bubble.set_text(text_queue.pop_front())
	speech_bubble.vertical_offset = vertical_offset
	speech_bubble.visible = true
	
func _process(delta):
	if speech_bubble.visible and text_delay != -1:
		text_delta += delta
		
		if text_delta > text_delay:
			if text_queue.size():
				text_delta = 0.0
				speech_bubble.set_text(text_queue.pop_front())
			else:				
				speech_bubble.visible = false
