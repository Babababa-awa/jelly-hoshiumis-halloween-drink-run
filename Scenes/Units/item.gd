extends Node2D

var current_item
var is_touching: bool = false

func _ready():
	scale = Vector2(0.25, 0.25)

func _process(_delta):		
	if can_pickup_item():
		pickup_item()	

func pickup_item():
	Global.audio.play_sfx("item_pickup")
	
	var index = Global.player.state.get_free_index()
	
	# Remove item from selected inventory spot
	var item = Global.player.state.remove_item(index)
	
	# Add this item to inventory spot
	Global.player.state.add_item(current_item, index)
	
	var parent = get_parent()

	# Remove item from level
	parent.remove_item(current_item)
			
	# Add dropped item to level
	if item != null:
		item.area = Global.level.current_area_name
		item.position = current_item.position
		item.meta = current_item.meta
		item.visible = true
		parent.add_item(item)
		
	current_item.meta = ""

func can_pickup_item() -> bool:
	if not is_touching:
		return false
	
	if not visible:
		return false
	
	if not Input.is_action_just_pressed("player_interact"):
		return false
		
	return true

func set_item(item: Item):
	$Image.set_cell(0, Vector2i(0, -1), $Image.tile_set.get_source_id(0), item.coords)
	position = item.position
	visible = item.visible
	current_item = item


func _on_area_item_body_entered(body):
	if body.is_in_group("player"):
		is_touching = true


func _on_area_item_body_exited(body):
	if body.is_in_group("player"):
		is_touching = false
