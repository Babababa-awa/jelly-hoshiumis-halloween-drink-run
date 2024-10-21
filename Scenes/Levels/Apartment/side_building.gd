extends Node2D

func _on_area_dead_body_entered(body):
	if body.is_in_group("player"):
		Global.player.do_dead = true

func _on_area_window_f_3_window_opened():
	var parent = get_parent()
	parent.change_area_zoom("third_floor_hallway", Vector2(16, -16))

func _on_area_window_f_4_window_opened():
	var parent = get_parent()
	parent.change_area_zoom("fourth_floor_hallway", Vector2(16, -16))

func _on_area_window_f_5_window_opened():
	var parent = get_parent()
	parent.change_area_zoom("fifth_floor_hallway", Vector2(16, -16))

func _on_area_notice_body_entered(body):
	if body.is_in_group("player"):
		Global.help.issue_notice("SideBuildingFireEscape")
