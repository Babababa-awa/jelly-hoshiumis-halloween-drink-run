extends TileMap

var is_on_matress: bool = false

func _process(_delta):
	if is_on_matress and Input.is_action_just_pressed("player_jump"):
		Global.audio.play_sfx("boing")


func _on_area_matress_body_entered(body):
	if body.is_in_group("player"):
		is_on_matress = true


func _on_area_matress_body_exited(body):
	if body.is_in_group("player"):
		is_on_matress = false
