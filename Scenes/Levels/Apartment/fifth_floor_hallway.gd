extends Node2D

func _on_apt_51_door_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fifth_floor_room_1", Vector2(368, -16))

func _on_apt_52_door_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fifth_floor_room_2", Vector2(368, -16))

func _on_area_door_floor_up_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fifth_floor_stairwell", Vector2(352, -16))

func _on_area_door_floor_down_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fourth_floor_stairwell", Vector2(64, -128))

func _on_area_door_maintenance_room_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("maintenance_room", Vector2(288, -16))

func _on_area_door_service_shaft_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("service_shaft", Vector2(64, -400))

func _on_window_fire_escape_window_opened():
	var parent = get_parent()
	parent.change_area_zoom("side_building", Vector2(352, -224))
