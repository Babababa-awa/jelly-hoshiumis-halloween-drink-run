extends Unit

const WALKING_SPEED = 30.0
const RUNNING_SPEED = 90.0
const LADDER_SPEED = 60.0
#const RUNNING_SPEED = 290.0
const JUMP_VELOCITY = -225

const JUMP_DELAY = 0.1

const INVULNERABLE_DELAY = 1.5

@onready var sprite_body = $Body
@onready var sprite_arms = $Arms
@onready var collision_shape = $CollisionShape2D

var state = PlayerState.new(50, 50)
var _mode: Global.PlayerMode = Global.PlayerMode.NORMAL

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_air_time: float = 0.0
var is_jumping: bool = false
var is_crouching: bool = false
var is_walking: bool = false
var is_on_ladder: bool = false
var current_ladder_climbing_time: float = 0.0

var movement: Global.PlayerMovement = Global.PlayerMovement.IDLE

var last_direction_x = 0
var lock_direction: bool = false # When true, player won't face forward until moved
var is_stabbing: bool = false
var is_stabbing_animation: bool = false

var is_pink_drink: bool = false
var is_dead: bool = false

var is_invulnerable: bool = false
var invulnerable_delay: float = 0.0

var do_dead: bool = false

func reset():
	is_pink_drink = false
	is_dead = false
	is_invulnerable = false
	do_dead = false
	state.reset()
	
func deal_anxiety(amount: int):
	if is_invulnerable:
		return
	
	Global.audio.play_sfx("sorry", 3)
	is_invulnerable = true
	invulnerable_delay = INVULNERABLE_DELAY
	Global.player.state.increase_anxiety(amount)
	if Global.player.state.anxiety == 100:
		do_dead = true

func set_mode(player_mode: Global.PlayerMode):
	_mode = player_mode
	
	is_jumping = false
	is_walking = false
	current_air_time = 0.0
	current_ladder_climbing_time = 0.0
	velocity.x = 0
	velocity.y = 0
	
	if _mode == Global.PlayerMode.NORMAL:
		is_on_ladder = false
	else:
		is_on_ladder = true

func _process(delta):
	if Global.game.is_paused:
		return
		
	if do_dead:
		do_dead = false
		Global.level.change_area("dead")
		return
	
	if Input.is_action_just_pressed("player_item_use"):
		use_item()
		
	if (is_invulnerable):
		invulnerable_delay -= delta
		if invulnerable_delay <= 0.0:
			is_invulnerable = false
	
	super._process(delta)

func use_item():
	var item = state.get_selected_item()
	
	if item == null:
		return
	
	match item.type:
		Global.ItemType.MEDICINE:
			state.decrease_anxiety(25)
			state.remove_item()
		Global.ItemType.FOOD:
			state.decrease_hunger(25)
			state.remove_item()
		Global.ItemType.FOOD_MEDICINE:
			state.decrease_anxiety(50)
			state.decrease_hunger(50)
			state.remove_item()
		Global.ItemType.KNIFE:
			is_stabbing = true
			Global.audio.play_sfx("swoosh", 3, true)

func _physics_process(delta):
	if not Global.game.is_physics_enabled:
		return
		
	if _mode == Global.PlayerMode.NONE or is_dead:
		if is_dead:
			sprite_body.play("dead")
			sprite_arms.play("idle")
		elif is_pink_drink:
			sprite_body.play("pink_drink")
			sprite_arms.play("idle")
		return
		
	if _mode == Global.PlayerMode.NORMAL:
		if is_on_ladder:
			if Input.is_action_just_pressed("player_crouch"):
				is_on_ladder = false
			elif not _is_on_ladder_tile():
				is_on_ladder = false
		elif Input.is_action_just_pressed("player_down"):
			if _is_above_ladder_tile():
				position += Vector2(0, 1)
				is_on_ladder = true				
				current_air_time = 0.0
				current_ladder_climbing_time = 0.0
				is_jumping = false
		elif Input.is_action_just_pressed("player_interact"):
			if _is_on_ladder_tile():
				is_on_ladder = true				
				current_air_time = 0.0
				current_ladder_climbing_time = 0.0
				is_jumping = false
		
		_normal_physics_process(delta)
	else: # Ladder
		_ladder_physics_process(delta)
		
		
	move_and_slide()
	
func _normal_physics_process(delta):
	if Input.is_action_pressed("player_crouch"):		
		if not is_crouching:
			is_crouching = true
			update_body_collision()
	elif is_crouching:
		is_crouching = false
		update_body_collision()
	
	if Input.is_action_pressed("player_walk"):
		is_walking = true
	else:
		is_walking = false
	
	# Add the gravity.
	if not is_on_ladder:
		if is_on_floor():
			current_air_time = 0
			is_jumping = false
		else:
			current_air_time += delta
			velocity.y += gravity * delta

	# Handle jump.
	if can_jump():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		is_on_ladder = false
	
	
	var direction_y = Input.get_axis("player_up", "player_down")
	var direction_x = Input.get_axis("player_left", "player_right")
	
	if direction_x != 0:
		last_direction_x = direction_x
		lock_direction = false
	
	if is_on_ladder:
		_vertical_physics_process(delta, direction_y)

	_horizontal_physics_process(delta, direction_x)
	
	update_sprite_state(direction_x, direction_y)
	update_movement(direction_x, direction_y)

func _ladder_physics_process(delta):
	var direction_y = Input.get_axis("player_up", "player_down")
	var direction_x = Input.get_axis("player_left", "player_right")
	
	if direction_x != 0:
		last_direction_x = direction_x
	
	_vertical_physics_process(delta, direction_y)
	update_sprite_state(direction_x, direction_y)
	update_movement(direction_x, direction_y)	

func update_sprite_state(direction_x: int, direction_y: int):
	if is_stabbing_animation:
		return
			
	if is_on_ladder:
		if direction_y != 0:
			sprite_body.play("climb_move")
			sprite_arms.play("climb_move")
		else:
			sprite_body.play("climb_idle")
			sprite_arms.play("climb_idle")
		
		sprite_body.flip_h = false
		sprite_arms.flip_h = false
		return
		
	var arm_suffix = ""
		
	if is_stabbing:
		update_knife_collision()
		arm_suffix = "_stab"
		is_stabbing_animation = true
		lock_direction = true
	elif is_knife_active():
		arm_suffix = "_knife"
	elif is_umbrella_active():
		arm_suffix = "_umbrella"
	
	var start_direction_x = direction_x
	if lock_direction:
		direction_x = last_direction_x
	
	if direction_x != 0:
		if is_crouching:
			sprite_body.play("crouch")
			sprite_arms.play("crouch" + arm_suffix)		
		elif is_jumping:
			sprite_body.play("jump_move")
			sprite_arms.play("run" + arm_suffix)
		elif start_direction_x == 0:
			sprite_body.play("idle_locked")
			sprite_arms.play("idle_locked" + arm_suffix)
		elif is_walking:
			sprite_body.play("walk")
			sprite_arms.play("walk" + arm_suffix)
		else:
			sprite_body.play("run")
			sprite_arms.play("run" + arm_suffix)
	else:
		if is_crouching:
			sprite_body.play("crouch_idle")
			sprite_arms.play("crouch_idle" + arm_suffix)
		elif is_jumping:
			sprite_body.play("jump_idle")
			sprite_arms.play("idle" + arm_suffix)
		else:
			sprite_body.play("idle")
			sprite_arms.play("idle" + arm_suffix)

	if direction_x < 0:
		sprite_body.flip_h = true
		sprite_arms.flip_h = true
	else:
		sprite_body.flip_h = false
		sprite_arms.flip_h = false

func update_movement(direction_x: int, _direction_y: int):
	if is_jumping:
		movement = Global.PlayerMovement.IDLE
	elif is_on_ladder:
		movement = Global.PlayerMovement.CLIMBING
	elif direction_x != 0:
		if is_walking:
			movement = Global.PlayerMovement.WALKING
		else:
			movement = Global.PlayerMovement.RUNNING
	else:
		movement = Global.PlayerMovement.IDLE

func _vertical_physics_process(delta, direction):
	if direction:
		if current_ladder_climbing_time > 0.5:
			current_ladder_climbing_time = 0.0
			
		if current_ladder_climbing_time == 0.0:
			Global.audio.play_sfx("metal_step", 4)
		
		current_ladder_climbing_time += delta
			
		if is_walking:
			velocity.y = direction * WALKING_SPEED
		else:
			velocity.y = direction * LADDER_SPEED
	else:
		current_ladder_climbing_time = 0.0
		velocity.y = 0

func _horizontal_physics_process(_delta, direction):
	if direction and (is_jumping or not is_crouching):
		if not is_jumping and is_walking:
			velocity.x = direction * WALKING_SPEED
		elif is_on_ladder:
			velocity.x = direction * LADDER_SPEED
		else:
			velocity.x = direction * RUNNING_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RUNNING_SPEED)
		
func update_knife_collision():
	if last_direction_x > 0:
		if is_crouching:
			$AreaKnife.position = Vector2(8, -2)
		else:
			$AreaKnife.position = Vector2(8, -10)
	else:
		if is_crouching:
			$AreaKnife.position = Vector2(-8, -2)
		else:
			$AreaKnife.position = Vector2(-8, -10)
	
func update_body_collision():
	if is_crouching:
		collision_shape.position = Vector2(-2, -8)
		collision_shape.shape.size = Vector2(4, 16)
	else:
		collision_shape.position = Vector2(-2, -12)
		collision_shape.shape.size = Vector2(4, 24)

func can_jump() -> bool:
	if Input.is_action_just_pressed("player_jump") and not is_jumping and not is_walking and current_air_time < JUMP_DELAY:
		return true
	else: 
		return false

func _on_area_head_body_entered(body):
	if is_instance_valid(body) and body is TileMap:
		_do_tile_collision_behavior(body)

func _do_tile_collision_behavior(body):
	# Character position at center bottom
	var head_position = position + Vector2(0, -32)
	
	if _is_tile_of_type(
		body,
		head_position,
		Global.TileType.CEILING
	):
		Global.audio.play_sfx("bonk")

func _is_above_ladder_tile() -> bool:
	if not Global.game or not Global.game.current_level or not Global.game.current_level.current_area:
		return false
		
	var parent = Global.game.current_level.current_area
	
	# Lower player by one pixel and check tile
	var test_position = position + Vector2(0, 1)
	
	for child in parent.get_children():
		if not child is TileMap:
			continue
		
		var tilemap = child as TileMap
		
		if not _is_tile_of_type(
			tilemap,
			test_position,
			Global.TileType.LADDER
		):
			continue
		
		# Ladder doesn't take up full tile so check that offset is still on ladder
		if not _is_tile_of_type(
			tilemap,
			test_position + Vector2(-4, 0),
			Global.TileType.LADDER
		):
			return false
	
		if not _is_tile_of_type(
			tilemap,
			test_position + Vector2(4, 0),
			Global.TileType.LADDER
		):
			return false
			
		return true
		
	return false
		
				
func _is_on_ladder_tile() -> bool:
	if not Global.game or not Global.game.current_level or not Global.game.current_level.current_area:
		return false
		
	var parent = Global.game.current_level.current_area
	
	var test_positions = [
		position + Vector2(0, -16), # top_
		position + Vector2(0, -1), # bottom (-1 since it triggers if on top otherwise)
	]
	
	for child in parent.get_children():
		if not child is TileMap:
			continue
		
		var tilemap = child as TileMap
		
		for test_position in test_positions:
			if not _is_tile_of_type(
				tilemap,
				test_position,
				Global.TileType.LADDER
			):
				continue
			
			# Ladder doesn't take up full tile so check that offset is still on ladder
			if not _is_tile_of_type(
				tilemap,
				test_position + Vector2(-4, 0),
				Global.TileType.LADDER
			):
				return false
		
			if not _is_tile_of_type(
				tilemap,
				test_position + Vector2(4, 0),
				Global.TileType.LADDER
			):
				return false
				
			return true
		
	return false
	
func _is_tile_of_type(
	tilemap: TileMap, 
	local_position: Vector2i, 
	tile_type: Global.TileType
) -> bool:
	var local_test_position = tilemap.local_to_map(local_position)
	var tile_id = tilemap.get_cell_source_id(0, local_test_position)
	if tile_id != -1:
		var data = tilemap.get_cell_tile_data(0, local_test_position)
		var test_tile_type = data.get_custom_data("tile_type")	

		if test_tile_type & tile_type != 0:
			return true
	
	return false


func _on_arms_animation_finished():
	if is_stabbing_animation:
		is_stabbing = false
		is_stabbing_animation = false
		
func is_knife_active() -> bool:
	return is_type_item_active(Global.ItemType.KNIFE)
	
func is_umbrella_active() -> bool:
	return is_type_item_active(Global.ItemType.UMBRELLA)

func is_type_item_active(item_type: Global.ItemType) -> bool:
	var item = state.get_selected_item()
	
	if item == null:
		return false
	
	if item.type == item_type:
		return true
	
	return false

func _on_area_knife_body_entered(body):
	if not is_stabbing:
		return

	if body.is_in_group("enemy"):
		if body.is_in_group("rrat"):
			body.is_dead = true
