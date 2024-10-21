extends Node2D

func _on_jelly_door_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("jelly_room", Vector2(368, -16))

func _on_apt_31_door_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("third_floor_room_1", Vector2(368, -16))

func _on_area_door_floor_up_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("third_floor_stairwell", Vector2(352, -16))

func _on_area_door_service_shaft_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("service_shaft", Vector2(64, -208))

func _on_window_fire_escape_window_opened():
	var parent = get_parent()
	parent.change_area_zoom("side_building", Vector2(352, 0))
