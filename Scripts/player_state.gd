class_name PlayerState

var hunger: int = 50
var anxiety: int = 50
var items: Array = [
	null,
	null,
	null,
	null
]
var selected_index: int = 0

func reset():
	hunger = 50
	anxiety = 50
	items = [
		null,
		null,
		null,
		null,
	]
	selected_index = 0	
	Global.hud.update_selected_item()
	Global.hud.update_item_image(0)
	Global.hud.update_item_image(1)
	Global.hud.update_item_image(2)
	Global.hud.update_item_image(3)

func get_free_index():
	if items[selected_index] == null:
		return selected_index
		
	for index in items.size():
		if items[index] == null:
			return index
	
	return selected_index

func _init(default_hunger, default_anxiety):
	hunger = default_hunger
	anxiety = default_anxiety

func add_item(item: Item, index: int = -1):
	if index == -1:
		index = selected_index
		
	items[index] = item
	Global.hud.update_item_image(index)
	
func remove_item(index: int = -1) -> Item:
	if index == -1:
		index = selected_index
		
	var item = items[index]
	items[index] = null
	Global.hud.update_selected_item()
	Global.hud.update_item_image(index)
	return item
	
func get_selected_item() -> Item:
	return items[selected_index]
	
func increase_hunger(amount):
	hunger = min(100, hunger + amount)

func decrease_hunger(amount):
	hunger = max(0, hunger - amount)
	
func increase_anxiety(amount):
	anxiety = min(100, anxiety + amount)
	
func decrease_anxiety(amount):
	anxiety = max(0, anxiety - amount)
	
func has_key(key_name: String) -> bool:
	for item in items:
		if item != null and item.type == Global.ItemType.KEY and item.name == key_name:
			return true
	return false

func has_lock_pick() -> bool:
	for item in items:
		if item != null and item.type == Global.ItemType.LOCK_PICK:
			return true
			
	return false
