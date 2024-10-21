extends Node2D

func _on_area_door_3_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("third_floor_hallway", Vector2(496, -16))

func _on_area_door_4_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fourth_floor_hallway", Vector2(496, -16))

func _on_area_door_5_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fifth_floor_hallway", Vector2(496, -16))
