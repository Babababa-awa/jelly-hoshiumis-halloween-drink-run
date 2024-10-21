extends TileMap

@export_enum("Apartment", "Fire") var door_type: String = "Apartment"
@export var lock_name: String = ""
@export var barricaded: bool = false

signal door_opened

var door_state = animation_state.new(2)

var is_in_vicinity = false

func _ready():
	if door_type == "Fire":
		var offset = 21
		
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(5, offset + 2))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(5, offset + 1))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(5, offset + 0))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(6, offset + 2))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(6, offset + 1))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(6, offset + 0))

func _process(delta):
	if Global.game.is_paused:
		return false
		
	door_state.process(delta)
	
	if _start_animation():
		Global.audio.play_sfx("door_open")
	elif door_state.requires_update:
		_open_door(door_state.current_step)
	elif door_state.is_complete:
		door_state.complete()
		Global.audio.play_sfx("door_close")
		door_opened.emit()

func _start_animation() -> bool:		
	if door_state.is_animating:
		return false
		
	if not Input.is_action_just_pressed("player_interact"):
		return false
	
	if is_in_vicinity:
		if barricaded:
			Global.player.show_speech_bubble("It's barricaded!\nI'll have to find\n a different route.", 2)
			return false
		elif Global.level.is_locked(lock_name):
			return false
			
		door_state.start("open_door")
		return true
	
	return false
	

		
func _open_door(step: int):
	var offset = 0
	
	match door_type:
		"Fire":
			offset = 21
			
	if step == 1:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(8, offset + 5))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(8, offset + 4))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(8, offset + 3))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(9, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(9, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(9, offset + 3))
	else:
		self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(10, offset + 5))
		self.set_cell(0, Vector2i(0, -2), self.tile_set.get_source_id(0), Vector2i(10, offset + 4))
		self.set_cell(0, Vector2i(0, -3), self.tile_set.get_source_id(0), Vector2i(10, offset + 3))
		self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(11, offset + 5))
		self.set_cell(0, Vector2i(1, -2), self.tile_set.get_source_id(0), Vector2i(11, offset + 4))
		self.set_cell(0, Vector2i(1, -3), self.tile_set.get_source_id(0), Vector2i(11, offset + 3))

func _on_area_vicinity_body_entered(body):
	if body.is_in_group("player"):
		is_in_vicinity = true

func _on_area_vicinity_body_exited(body):
	if body.is_in_group("player"):
		is_in_vicinity = false

