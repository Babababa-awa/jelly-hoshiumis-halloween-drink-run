extends Node2D

func _on_area_door_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("third_floor_hallway", Vector2(768, -16))
