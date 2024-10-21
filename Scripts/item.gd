class_name Item

static var next_id: int = 0

var id: int
var name: String
var type: Global.ItemType
var coords: Vector2i
var area: String
var position: Vector2i
var visible: bool
var meta: String

func _init(
	item_name: String, 
	item_type: Global.ItemType, 
	item_coords: Vector2i, 
	item_area: String, 
	item_position: Vector2i, 
	item_visible: bool = true, 
	item_meta: String = ""
):
	next_id += 1
	
	id = next_id
	name = item_name
	type = item_type
	coords = item_coords
	area = item_area
	position = item_position
	visible = item_visible
	meta = item_meta
	

