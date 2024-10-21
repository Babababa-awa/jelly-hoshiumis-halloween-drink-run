extends TileMap

var is_in_vicinity: bool = false

func _process(_delta):
	if is_in_vicinity and Global.player.movement == Global.PlayerMovement.RUNNING:
		Global.player.deal_anxiety(10)

func _on_area_damage_body_entered(body):
	if body.is_in_group("player"):
		is_in_vicinity = true
	
func _on_area_damage_body_exited(body):
	if body.is_in_group("player"):
		is_in_vicinity = false

func _on_area_notice_left_body_entered(body):
	if body.is_in_group("player"):
		Global.help.issue_notice("Glass")
	
func _on_area_notice_right_body_entered(body):
	if body.is_in_group("player"):
		Global.help.issue_notice("Glass")
