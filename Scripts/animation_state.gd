class_name animation_state

var name: String = "default"
var is_on: bool = false
var is_animating: bool = false
var current_step: int = 0
var current_delta: float = 0.0
var requires_update: bool = false
var is_complete: bool = false

var animation_delta: float
var total_animation_steps: int


func _init(total_steps: int, delta: float = 0.125):
	total_animation_steps = total_steps
	animation_delta = delta
	
func process(delta: float):
	requires_update = false
	
	if is_animating and current_step > total_animation_steps:
		is_complete = true
		is_animating = false
	
	if is_complete:
		return

	if is_animating:
		current_delta += delta
		var step = ceil(current_delta / animation_delta)
		if current_step != step:
			current_step = step
			requires_update = true

func complete():
	is_complete = false
	

func start(animation_name: String):
	name = animation_name
	is_animating = true
	current_step = 0
	current_delta = 0.0
	requires_update = false
	is_complete = false
	

