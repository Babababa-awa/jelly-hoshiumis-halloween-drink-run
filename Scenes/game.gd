extends Node
class_name Game

var current_level
var is_paused: bool = false
var _load_delta: float = -1.0
var is_physics_enabled = false

var rain: bool = true
var is_outside: bool = true
var is_lightning: bool = true

func reset():
	current_level = null
	Global.help.reset()

func _ready() -> void:
	Global.game = self
	Global.player = $Level/Player
	Global.camera = $Level/Player/Camera
	Global.help = Help.new()
	Global.audio = Audio.new()
	Global.audio.load_sfx("bonk")
	Global.audio.load_sfx("item_pickup")
	Global.audio.load_music("room")
	Global.audio.load_music("hallway")
	Global.audio.load_music("roof")
	Global.audio.load_rain()
	Global.audio.play_rain()

func start_load():
	Global.camera.position_smoothing_enabled = false
	is_physics_enabled = false
	
func end_load():
	_load_delta = 0.0
	
	
func position_player(
	parent_scene: Node2D, 
	offset: Vector2,
	player_mode: Global.PlayerMode = Global.PlayerMode.NORMAL
):
	Global.player.set_mode(player_mode)
	Global.player.position = parent_scene.global_position + offset
	
func _process(delta):
	if (_load_delta >= 0.0):
		_load_delta += delta
		if _load_delta > 0.1:
			_load_delta = -1.0
			Global.camera.position_smoothing_enabled = true
			is_physics_enabled = true
	
	if Input.is_action_just_pressed("game_pause") and current_level != null:
		if is_paused:
			if $UI/Pause.visible:
				toggle_pause()
		else:
			toggle_pause()

func change_level(level_name: String):	
	if current_level != null:
		$Level.remove_child(current_level)
		current_level.queue_free()
		
	var level_path = "res://Scenes/Levels/" + level_name + ".tscn"
	
	var new = await load(level_path).instantiate()
	
	$Level.add_child(new)
	current_level = new
	Global.level = new
	$Level.visible = true
	$Level/Player.visible = true
	
	$UI/Hud.visible = true
	$UI/Menu.hide_ui()
	$UI/Settings.hide_ui()
	Engine.time_scale = 1
	
func toggle_pause():
	if is_paused:
		is_physics_enabled = true
		Engine.time_scale = 1
		$UI/Pause.hide_ui()
	else:
		Engine.time_scale = 0
		is_physics_enabled = false
		$UI/Pause.show_ui()
	
	is_paused = !is_paused

func show_controls():
	if is_paused:
		$UI/Pause.hide_ui()
	else:
		$UI/Menu.hide_ui()
	
	$UI/Controls.show_ui()

func hide_controls():
	if is_paused:
		$UI/Pause.show_ui()
	else:
		$UI/Menu.show_ui()
	
	$UI/Controls.hide_ui()

func show_settings():
	if is_paused:
		$UI/Pause.hide_ui()
	else:
		$UI/Menu.hide_ui()
	
	$UI/Settings.show_ui()
	
func hide_settings():
	if is_paused:
		$UI/Pause.show_ui()
	else:
		$UI/Menu.show_ui()
	
	$UI/Settings.hide_ui()

func goto_menu():	
	current_level.queue_free()
	current_level = null
	$Level.visible = false
	$Level/Player.visible = false
	$UI/Hud.visible = false
	$UI/Settings.hide_ui()
	$UI/Controls.hide_ui()
	$UI/Pause.hide_ui()
	is_paused = false
	is_physics_enabled = false
	Global.camera.position_smoothing_enabled = false
	Engine.time_scale = 1
	Global.player.position = Vector2(0, 0)
	Global.audio.stop_music()
	Global.audio.play_rain()
	is_outside = true
	is_lightning = true
	$UI/Menu.show_ui()
