extends Node2D
class_name Level

const ITEM_PATH = "res://Scenes/Units/item.tscn"

var current_area
var current_area_name
var level_name: String
var items: Array[Item]
var music: Dictionary
var rain: Dictionary
var locks: Dictionary

func change_area(
	area_name: String, 
	player_position: Vector2 = Vector2.ZERO,
	player_mode: Global.PlayerMode = Global.PlayerMode.NORMAL
):
	Global.game.start_load()
	
	if current_area != null:
		remove_items()
		remove_child(current_area)
		current_area.queue_free()
	
		Global.player.state.increase_hunger(5)
		if Global.player.state.hunger == 100:
			area_name = "dead"
	
	current_area_name = area_name	
	var area_path = "res://Scenes/Levels/" + level_name + "/" + area_name + ".tscn"
	
	var new = await load(area_path).instantiate()
	current_area = new
	add_child(new)
	
	populate_area_items()
	
	if music.has(area_name):
		if music[area_name] != null:
			Global.audio.play_music(music[area_name])
		else: 
			Global.audio.stop_music()
	else:
		Global.audio.play_music(music["_default"])
		
	if rain.has(area_name):
		Global.game.is_outside = rain[area_name].outside
		Global.game.is_lightning = rain[area_name].lightning
		Global.audio.play_rain()
	else:
		Global.game.is_outside = false
		Global.game.is_lightning = false
		Global.audio.stop_rain()
			
		
	Global.game.position_player(new, player_position, player_mode)
	Global.game.end_load()

	
func change_area_zoom(
	area_name: String, 
	player_position: Vector2, 
	player_mode: Global.PlayerMode = Global.PlayerMode.NORMAL
):
	# TODO: add effect that pauses engine, zooms in 
	# player camera, then switches area
	change_area(area_name, player_position, player_mode)

func remove_items():
	for child in get_children():
		if child.scene_file_path == ITEM_PATH:
			remove_child(child)

func populate_area_items():
	for item in items:
		if item.area == current_area_name:
			var new = await load(ITEM_PATH).instantiate()
			new.set_item(item)
			add_child(new)

func remove_item(item):
	for index in items.size():
		if items[index] != null and items[index].id == item.id:
			items.remove_at(index)
			break
	
	for child in get_children():
		if child.scene_file_path == ITEM_PATH:
			if child.current_item.id == item.id:
				remove_child(child)
				break

func add_item(item):
	var new = await load(ITEM_PATH).instantiate()
	new.set_item(item)
	add_child(new)
	
	items.push_back(item)
	
func get_item_instance(meta: String):
	for child in get_children():
		if child.scene_file_path == ITEM_PATH:
			if child.current_item.meta == meta:
				return child
	
	return null
	
func is_locked(lock_name: String):
	if lock_name == "":
		return false
				
	if not locks.has(lock_name):
		Global.player.show_speech_bubble("It's locked!", 2)
		Global.audio.play_sfx("locked_door", 3)
		return true
		
	if locks[lock_name].unlocked:
		return false
	
	for key in locks[lock_name].keys:
		if Global.player.state.has_key(key):
			# TODO: Play unlocking sound
			locks[lock_name].unlocked = true
			Global.audio.play_sfx("unlock", 3)
			return false
			
	if locks[lock_name].pickable and Global.player.state.has_lock_pick():
		Global.audio.play_sfx("unlock", 3)
		locks[lock_name].unlocked = true
		return false
	
	Global.player.show_speech_bubble("It's locked!", 2)
	Global.audio.play_sfx("locked_door", 3)
	return true
	
