extends Control

var current_hunger = 0
var current_anxiety = 0
var selected_index = 0

const ITEM_BORDER_COLOR = "#000000"
const SELECTED_ITEM_BORDER_COLOR = "#00FF00"

var item_texture = preload("res://Assets/items.png")

func _ready():
	Global.hud = self
	update_hunger_bar()
	update_anxiety_bar()
	update_selected_item()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Global.player or Global.game.is_paused:
		return
		
	if current_hunger != Global.player.state.hunger:
		current_hunger = Global.player.state.hunger
		update_hunger_bar()
		
	if current_anxiety != Global.player.state.anxiety:
		current_anxiety = Global.player.state.anxiety
		update_anxiety_bar()
		
	if Input.is_action_just_pressed("player_item_right"):
		if selected_index == 3:
			selected_index = 0
		else:
			selected_index += 1
		update_selected_item()
	elif Input.is_action_just_pressed("player_item_left"):
		if selected_index == 0:
			selected_index = 3
		else:
			selected_index -= 1
		update_selected_item()
	elif Input.is_action_just_pressed("player_item_select_1"):
		selected_index = 0
		update_selected_item()
	elif Input.is_action_just_pressed("player_item_select_2"):
		selected_index = 1
		update_selected_item()
	elif Input.is_action_just_pressed("player_item_select_3"):
		selected_index = 2
		update_selected_item()
	elif Input.is_action_just_pressed("player_item_select_4"):
		selected_index = 3
		update_selected_item()

func update_item_image(index: int = -1):
	var image

	match index:
		0:
			image = %Item1
		1:
			image = %Item2
		2:
			image = %Item3
		3:
			image = %Item4
	
	var item = Global.player.state.items[index]
	
	if item == null:
		image.visible = false
		return
		
	var offset = Vector2(item.coords.x * 32, item.coords.y * 32)
	
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = item_texture
	atlas_texture.region = Rect2(offset, Vector2(32, 32))
	image.texture = atlas_texture
	image.visible = true
	
	if index == selected_index:
		_update_selected_item_text()

func update_selected_item():
	%Item1Border.color = Color(ITEM_BORDER_COLOR)
	%Item2Border.color = Color(ITEM_BORDER_COLOR)
	%Item3Border.color = Color(ITEM_BORDER_COLOR)
	%Item4Border.color = Color(ITEM_BORDER_COLOR)
	
	match selected_index:
		0:
			%Item1Border.color = Color(SELECTED_ITEM_BORDER_COLOR)
		1:
			%Item2Border.color = Color(SELECTED_ITEM_BORDER_COLOR)
		2:
			%Item3Border.color = Color(SELECTED_ITEM_BORDER_COLOR)
		3:
			%Item4Border.color = Color(SELECTED_ITEM_BORDER_COLOR)
	
	if Global.player:
		Global.player.state.selected_index = selected_index
		_update_selected_item_text()
		
func _update_selected_item_text():
	var item = Global.player.state.get_selected_item()
	if item == null:
		%LabelItemName.text = ''
	else:
		%LabelItemName.text = item.name
			

func update_hunger_bar():
	var container = %HungerBar.get_parent()
	var available_width = container.get_size().x - container.get_theme_constant("margin_left") - container.get_theme_constant("margin_right")
	var bar_size = %HungerBar.get_custom_minimum_size()
	bar_size.x = ceil(available_width * current_hunger / 100)	
	%HungerBar.set_custom_minimum_size(bar_size)
	
func update_anxiety_bar():
	var container = %AnxietyBar.get_parent()
	var available_width = container.get_size().x - container.get_theme_constant("margin_left") - container.get_theme_constant("margin_right")
	var bar_size = %AnxietyBar.get_custom_minimum_size()
	bar_size.x = ceil(available_width * current_anxiety / 100)	
	%AnxietyBar.set_custom_minimum_size(bar_size)

func _on_hunger_bar_container_resized():
	update_hunger_bar()


func _on_anxiety_bar_container_resized():
	update_anxiety_bar()
