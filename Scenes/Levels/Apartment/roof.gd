extends Node2D

var is_in_fire_escape_vicinity: bool = false

func _process(_delta):
	if is_in_fire_escape_vicinity:
		if Input.is_action_just_pressed("player_interact"):	
			Global.audio.play_sfx("metal_step", 4)
			var parent = get_parent()
			parent.change_area("fire_escape", Vector2(384, 48), Global.PlayerMode.LADDER)
		

func _on_area_door_stairwell_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fifth_floor_stairwell", Vector2(64, -128))

func _on_area_door_maintenance_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("maintenance_room", Vector2(64, -16))


func _on_area_fire_escape_body_entered(body):
	if body.is_in_group("player"):
		is_in_fire_escape_vicinity = true


func _on_area_fire_escape_body_exited(body):
	if body.is_in_group("player"):
		is_in_fire_escape_vicinity = false


func _on_area_ladder_body_entered(body):
	if body.is_in_group("player"):
		Global.player.show_speech_bubble("That ladder is\nmy exit!", 2)
