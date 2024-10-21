extends Node2D

@export_range(4, 20) var path_width: int = 5

@onready var ghost = $Ghost

func _ready():
	ghost.position.x = (path_width * 16 / 2.0)
	$AreaRight.position.x = path_width * 16
	
	var random_value = 1 if randf_range(0.0, 1.0) < 0.5 else -1
	ghost.direction = random_value

func _on_area_left_body_entered(body):
	if body == ghost:
		ghost.direction *= -1

func _on_area_right_body_entered(body):
	if body == ghost:
		ghost.direction *= -1
