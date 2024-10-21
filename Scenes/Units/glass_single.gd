extends TileMap

@export_range(1, 3) var tile: int = 1

var is_in_vicinity: bool = false

func _ready():
	match tile:
		1:
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(9, 10))
		2:
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(10, 10))
		3:
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(11, 10))

func _process(_delta):
	if is_in_vicinity and Global.player.movement == Global.PlayerMovement.RUNNING:
		Global.player.deal_anxiety(10)

func _on_area_damage_body_entered(body):
	if body.is_in_group("player"):
		is_in_vicinity = true
	
func _on_area_damage_body_exited(body):
	if body.is_in_group("player"):
		is_in_vicinity = false
