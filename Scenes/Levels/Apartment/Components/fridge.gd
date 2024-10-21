extends TileMap

signal fridge_opened
signal fridge_closed

var fridge_state = animation_state.new(1)

var is_in_vicinity = false

func _process(delta):
	fridge_state.process(delta)
	
	if _start_open_fridge_animation():
		Global.audio.play_sfx("fridge_open")
		fridge_state.is_on = true
	elif _start_close_fridge_animation():
		Global.audio.play_sfx("fridge_close")
		fridge_state.is_on = false
	elif fridge_state.requires_update:
		match fridge_state.name:
			"open_fridge":
				_open_fridge(fridge_state.current_step)
			"close_fridge":
				_close_fridge(fridge_state.current_step)
	elif fridge_state.is_complete:
		fridge_state.complete()
		match fridge_state.name:
			"open_fridge":
				fridge_opened.emit()
			"close_fridge":
				fridge_closed.emit()
			
func _start_open_fridge_animation() -> bool:
	if fridge_state.is_animating:
		return false
		
	if not is_in_vicinity:
		return false
		
	if fridge_state.is_on:
		return false
		
	if not Input.is_action_just_pressed("player_interact"):
		return false
	
	fridge_state.start("open_fridge")
	return true

	
func _start_close_fridge_animation() -> bool:
	if fridge_state.is_animating or not fridge_state.is_on:
		return false
		
	if is_in_vicinity:
		return false

	fridge_state.start("close_fridge")
	return true


func _open_fridge(step: int):
	if step == 1:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(11,8))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(11,7))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(11,6))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(12,8))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(12,7))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(12,6))

func _close_fridge(step: int):
	if step == 1:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(9,8))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(9,7))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(9,6))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(10,8))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(10,7))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(10,6))

func _on_area_fridge_body_entered(body):
	if body.is_in_group("player"):
		is_in_vicinity = true

func _on_area_fridge_body_exited(body):
	if body.is_in_group("player"):
		is_in_vicinity = false
