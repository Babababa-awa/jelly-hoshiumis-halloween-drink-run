extends TileMap

@export_enum("Apartment", "Fire") var door_type: String = "Apartment"
@export var lock_name: String = ""

var door_state = animation_state.new(2)

var is_on_left_side = false
var is_on_right_side = false
var is_in_vicinity = false

func _ready():
	if door_type == "Fire":
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(4,21))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(4,22))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(4,23))

func _process(delta):
	if Global.game.is_paused:
		return false
		
	door_state.process(delta)
	
	if _start_open_door_animation():
		Global.audio.play_sfx("door_open")
		door_state.is_on = true
	elif _start_close_door_animation():
		Global.audio.play_sfx("door_close")
		door_state.is_on = false
	elif door_state.requires_update:
		match door_state.name:
			"open_door_left":
				_open_door_left(door_state.current_step)
			"open_door_right":
				_open_door_right(door_state.current_step)
			"close_door_left":
				_close_door_left(door_state.current_step)
			"close_door_right":
				_close_door_right(door_state.current_step)
	elif door_state.is_complete:
		door_state.complete()

func _start_open_door_animation() -> bool:
	if door_state.is_animating:
		return false
		
	if door_state.is_on:
		return false
		
	if not Input.is_action_just_pressed("player_interact"):
		return false
	
	if is_on_left_side:
		if Global.level.is_locked(lock_name):
			return false
		door_state.start("open_door_left")
		return true
	elif is_on_right_side:
		if Global.level.is_locked(lock_name):
			return false
		door_state.start("open_door_right")
		return true
	
	return false
	
func _start_close_door_animation() -> bool:
	if door_state.is_animating or not door_state.is_on:
		return false
		
	if is_in_vicinity:
		return false

	if door_state.name == "open_door_left":
		door_state.start("close_door_left")
		return true
	elif door_state.name == "open_door_right":
		door_state.start("close_door_right")
		return true
	
	return false

func _open_door_left(step: int):
	var offset = 0
	
	match door_type:
		"Fire":
			offset = 21
	
	if step == 1:
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(0, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(0, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(0, offset + 3))
		self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(1, offset + 5))
		self.set_cell(0, Vector2i(2, -2), self.tile_set.get_source_id(0), Vector2i(1, offset + 4))
		self.set_cell(0, Vector2i(2, -3), self.tile_set.get_source_id(0), Vector2i(1, offset + 3))
	else:
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(2, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(2, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(2, offset + 3))
		self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(3, offset + 5))
		self.set_cell(0, Vector2i(2, -2), self.tile_set.get_source_id(0), Vector2i(3, offset + 4))
		self.set_cell(0, Vector2i(2, -3), self.tile_set.get_source_id(0), Vector2i(3, offset + 3))
								
func _open_door_right(step: int):
	var offset = 0
	
	match door_type:
		"Fire":
			offset = 21
			
	if step == 1:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(4, offset + 5))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(4, offset + 4))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(4, offset + 3))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(5, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(5, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(5, offset + 3))
	else:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(6, offset + 5))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(6, offset + 4))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(6, offset + 3))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(7, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(7, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(7, offset + 3))
	
func _close_door_left(step: int):
	var offset = 0
	
	match door_type:
		"Fire":
			offset = 21
			
	if step == 1:
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(0, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(0, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(0, offset + 3))
		self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(1, offset + 5))
		self.set_cell(0, Vector2i(2, -2), self.tile_set.get_source_id(0), Vector2i(1, offset + 4))
		self.set_cell(0, Vector2i(2, -3), self.tile_set.get_source_id(0), Vector2i(1, offset + 3))
	else:
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(4, offset + 0))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(4, offset + 1))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(4, offset + 2))
		self.set_cell(0, Vector2i(2, -1))
		self.set_cell(0, Vector2i(2, -2))
		self.set_cell(0, Vector2i(2, -3))
		
func _close_door_right(step: int):
	var offset = 0
	
	match door_type:
		"Fire":
			offset = 21
			
	if step == 1:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(4, offset + 5))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(4, offset + 4))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(4, offset + 3))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(5, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(5, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(5, offset + 3))
	else:
		self.set_cell(0, Vector2i(0, -1))
		self.set_cell(0, Vector2i(0, -2))
		self.set_cell(0, Vector2i(0, -3))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(4, offset + 0))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(4, offset + 1))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(4, offset + 2))

func _on_area_left_side_body_entered(body):
	if body.is_in_group("player"):
		is_on_left_side = true

func _on_area_left_side_body_exited(body):
	if body.is_in_group("player"):
		is_on_left_side = false

func _on_area_right_side_body_entered(body):
	if body.is_in_group("player"):
		is_on_right_side = true

func _on_area_right_side_body_exited(body):
	if body.is_in_group("player"):
		is_on_right_side = false

func _on_area_vicinity_body_entered(body):
	if body.is_in_group("player"):
		is_in_vicinity = true

func _on_area_vicinity_body_exited(body):
	if body.is_in_group("player"):
		is_in_vicinity = false

