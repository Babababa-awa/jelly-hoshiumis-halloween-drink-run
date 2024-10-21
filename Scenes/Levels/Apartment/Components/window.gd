extends TileMap

signal window_opened

var window_state = animation_state.new(2)

var is_in_vicinity = false

func _process(delta):
	window_state.process(delta)
	
	if _start_animation():
		Global.audio.play_sfx("window_open")
	elif window_state.requires_update:
		_open_window(window_state.current_step)
	elif window_state.is_complete:
		window_state.complete()
		Global.audio.play_sfx("window_close")
		window_opened.emit()

func _start_animation() -> bool:
	if window_state.is_animating:
		return false
		
	if not Input.is_action_just_pressed("player_interact"):
		return false
	
	if is_in_vicinity:
		window_state.start("open_window")
		return true
	
	return false

func _open_window(step: int):
	var offset = 0
			
	if step == 1:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(18, offset + 9))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(18, offset + 8))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(18, offset + 7))
		self.set_cell(0, Vector2i(0, -4), self.tile_set.get_source_id(0), Vector2i(18, offset + 6))
		self.set_cell(0, Vector2i(0, -5), self.tile_set.get_source_id(0), Vector2i(18, offset + 5))
	else:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(19, offset + 9))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(19, offset + 8))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(19, offset + 7))
		self.set_cell(0, Vector2i(0, -4), self.tile_set.get_source_id(0), Vector2i(19, offset + 6))
		self.set_cell(0, Vector2i(0, -5), self.tile_set.get_source_id(0), Vector2i(19, offset + 5))

func _on_area_vicinity_body_entered(body):
	if body.is_in_group("player"):
		is_in_vicinity = true

func _on_area_vicinity_body_exited(body):
	if body.is_in_group("player"):
		is_in_vicinity = false

