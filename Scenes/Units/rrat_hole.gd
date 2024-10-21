extends TileMap

const RESPAWN_DELAY = 4

var respawn_delta: float = 0.0

@onready var rrat = $Rrat

func _ready():
	var random_value = 1 if randf_range(0.0, 1.0) < 0.5 else -1
	rrat.direction = random_value
		
func _process(delta):
	if rrat.is_dead:
		respawn_delta += delta
		if respawn_delta > RESPAWN_DELAY:
			respawn_delta = 0.0
			rrat.reset()
			rrat.position = Vector2(72, 0)

func _on_area_left_body_entered(body):
	if body == rrat:
		rrat.direction *= -1

func _on_area_right_body_entered(body):
	if body == rrat:
		rrat.direction *= -1
