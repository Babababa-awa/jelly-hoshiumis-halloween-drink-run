extends TileMap

@export_range(16, 384) var drop_height: int = 44

var current_full: int = 0
var current_remainder: int = 0

func _ready():
	$Spider.drop_height = drop_height

func _process(_delta):
	var y = $Spider.position.y
	var full = max(0, floor(y / 16))
	var remainder = int(round(y - (full * 16)))
	
	current_full = -1
	
	if full != current_full or remainder != current_remainder:
		current_full = full
		current_remainder = remainder

		# Draw current state
		var current_y = 0
		for i in full:
			self.set_cell(0, Vector2i(0, current_y), self.tile_set.get_source_id(0), Vector2i(16, 0))
			current_y += 1
		
		if remainder > 0:
			if remainder > 12:
				self.set_cell(0, Vector2i(0, current_y), self.tile_set.get_source_id(0), Vector2i(16, 1))
				current_y += 1
			elif remainder > 8:
				self.set_cell(0, Vector2i(0, current_y), self.tile_set.get_source_id(0), Vector2i(16, 2))
				current_y += 1
			elif remainder > 4:
				self.set_cell(0, Vector2i(0, current_y), self.tile_set.get_source_id(0), Vector2i(16, 3))
				current_y += 1
				
		# Clear
		var max_drop = int(ceil(drop_height / 16.0)) + 1
		for i in range(current_y, max_drop):
			self.set_cell(0, Vector2i(0, i))
