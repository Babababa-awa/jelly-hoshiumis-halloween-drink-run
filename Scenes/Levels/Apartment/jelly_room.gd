extends Node2D

func _on_area_door_door_opened():
	var parent = get_parent()
	parent.change_area_zoom("third_floor_hallway", Vector2(208, -16))

func _on_fridge_fridge_opened():
	var parent = get_parent()
	
	var item = parent.get_item_instance("fridge")
	if item:
		item.visible = true

func _on_fridge_fridge_closed():
	var parent = get_parent()
	
	var item = parent.get_item_instance("fridge")
	if item:
		item.visible = false
