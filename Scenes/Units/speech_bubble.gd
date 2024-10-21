extends TileMap

@export_enum("Left", "Center", "Right") var direction: String = "Center"
var _current_direction: String = "Center"

var vertical_offset: float = -32

@onready var _label = $Text

func set_text(text: String):
	_label.text = text

# Called when the node enters the scene tree for the first time.
func _ready():
	match direction:
		"Left":
			position = Vector2(0, vertical_offset)
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(0, 2))
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(1, 1))
			self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(2, 1))
		"Center":
			position = Vector2(-24, vertical_offset)
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(0, 1))
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(1, 2))
			self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(2, 1))
		"Right":
			position = Vector2(-48, vertical_offset)
			self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(0, 1))
			self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(1, 1))
			self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(2, 2))

func _process(_delta):
	match direction:
		"Left":
			position = Vector2(0, vertical_offset)
		"Center":
			position = Vector2(-24, vertical_offset)
		"Right":
			position = Vector2(-48, vertical_offset)
	
	if _current_direction != direction:
		_current_direction = direction
		match direction:
			"Left":
				position = Vector2(0, vertical_offset)
				self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(0, 2))
				self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(1, 1))
				self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(2, 1))
			"Center":
				position = Vector2(-24, vertical_offset)
				self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(0, 1))
				self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(1, 2))
				self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(2, 1))
			"Right":
				position = Vector2(-48, vertical_offset)
				self.set_cell(0, Vector2i(0, -1), self.tile_set.get_source_id(0), Vector2i(0, 1))
				self.set_cell(0, Vector2i(1, -1), self.tile_set.get_source_id(0), Vector2i(1, 1))
				self.set_cell(0, Vector2i(2, -1), self.tile_set.get_source_id(0), Vector2i(2, 2))
