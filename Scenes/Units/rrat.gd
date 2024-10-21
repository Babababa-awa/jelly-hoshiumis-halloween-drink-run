extends Unit

const SPEED = 80.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_body = $Body

var direction = 0
var is_dead: bool = false
var is_dead_animation: bool = false
var speed_modifier = 0

func _ready():
	speed_modifier = randi_range(-20, 20)

func reset():
	speed_modifier = randi_range(-20, 20)
	is_dead = false
	is_dead_animation = false

func _process(_delta):
	if is_dead and not is_dead_animation:
		sprite_body.play("dead")
		is_dead_animation = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if not is_dead_animation:
		if direction != 0:
			if direction > 0:
				sprite_body.play("run")
				sprite_body.flip_h = true
			else:
				sprite_body.play("run")
				sprite_body.flip_h = false
				
			velocity.x = direction * (SPEED + speed_modifier)
		else:
			sprite_body.play("idle")
			velocity.x = move_toward(velocity.x, 0, (SPEED + speed_modifier))

	move_and_slide()


func _on_damage_body_entered(body):
	if not is_dead and body.is_in_group("player"):
		Global.player.deal_anxiety(15)

