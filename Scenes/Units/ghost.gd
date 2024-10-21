extends CharacterBody2D

const SPEED = 80.0

@onready var sprite_body = $Body

var direction = 0
var speed_modifier = 0

func _ready():
	speed_modifier = randi_range(-20, 20)

func reset():
	speed_modifier = randi_range(-20, 20)

func _physics_process(_delta):
	velocity.y = 0
	
	if direction != 0:
		if direction > 0:
			sprite_body.flip_h = false
		else:
			sprite_body.flip_h = true
			
		velocity.x = direction * (SPEED + speed_modifier)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED + speed_modifier))

	move_and_slide()


func _on_area_damage_body_entered(body):
	if body.is_in_group("player"):
		Global.player.deal_anxiety(20)
