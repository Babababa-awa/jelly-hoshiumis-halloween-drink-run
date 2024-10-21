extends Node2D

func _on_area_door_bottom_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("third_floor_hallway", Vector2(1216, -16))

func _on_area_door_top_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fourth_floor_hallway", Vector2(1504, -16))
