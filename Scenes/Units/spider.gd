extends CharacterBody2D

const SPEED = 50.0

var start_position: Vector2
var direction = 1
var drop_height = 42
var speed_modifier = 0

func reset():
	position = start_position
	speed_modifier = randi_range(-10, 10)


func _ready():
	speed_modifier = randi_range(-10, 10)
	start_position = position

func _process(delta):
	if position.y >= drop_height:
		direction = -1
	elif position.y <= 0:
		direction = 1
		
	position.y += direction * (SPEED + speed_modifier) * delta

func _on_area_damage_body_entered(body):
	if body.is_in_group("player"):
		Global.player.deal_anxiety(10)
