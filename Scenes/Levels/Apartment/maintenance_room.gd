extends Node2D

func _on_area_door_f_5_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("fifth_floor_hallway", Vector2(128, -112))

func _on_area_door_roof_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("roof", Vector2(352, -16))
