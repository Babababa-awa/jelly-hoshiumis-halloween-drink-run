extends Level

func _ready():
	level_name = "Apartment"
	items = [
		# Jelly Room
		Item.new("Cigarettes", Global.ItemType.MEDICINE, Vector2i(6, 0), "jelly_room", Vector2i(149, -32)),
		Item.new("Kitchen Knife", Global.ItemType.KNIFE, Vector2i(0, 0), "jelly_room", Vector2i(434, -43)),
		Item.new("Meal Replacement", Global.ItemType.FOOD, Vector2i(1, 1), "jelly_room", Vector2i(500, -32), false, 'fridge'),
				
		# Third Floor Hallway
		Item.new("Anxiety Medication", Global.ItemType.MEDICINE, Vector2i(1, 0), "third_floor_hallway", Vector2i(1438, -16)),
		
		# Side Building
		Item.new("Energy Drink", Global.ItemType.FOOD_MEDICINE, Vector2i(4, 1), "side_building", Vector2i(295, 0)),
		
		# Fourth Floor Stairwell
		Item.new("Canned Tuna", Global.ItemType.FOOD, Vector2i(7, 0), "fourth_floor_stairwell", Vector2i(148, -96)),
		
		# Fifth Floor Stairwell
		Item.new("Energy Drink", Global.ItemType.FOOD_MEDICINE, Vector2i(4, 1), "fifth_floor_stairwell", Vector2i(24, -128)),
		
		# Fifth Floor Hallway
		Item.new("Anxiety Medication", Global.ItemType.MEDICINE, Vector2i(1, 0), "fifth_floor_hallway", Vector2i(1524, -16)),
		Item.new("Cigarettes", Global.ItemType.MEDICINE, Vector2i(6, 0), "fifth_floor_hallway", Vector2i(1462, -16)),
		
		# Apartment 4-1
		Item.new("Anxiety Medication", Global.ItemType.MEDICINE, Vector2i(1, 0), "fourth_floor_room_1", Vector2i(24, -22)),
		Item.new("Moo Deng Jerky", Global.ItemType.FOOD, Vector2i(2, 0), "fourth_floor_room_1", Vector2i(428, -32)),
		
		# Apartment 4-2
		Item.new("Chicken Dinner", Global.ItemType.FOOD, Vector2i(5, 1), "fourth_floor_room_2", Vector2i(524, -32), false, 'fridge'),
		
		# Apartment 5-1
		Item.new("Lock Picks", Global.ItemType.LOCK_PICK, Vector2i(3, 0), "fifth_floor_room_1", Vector2i(80, -27)),
		
		# Apartment 5-2
		Item.new("Master Key", Global.ItemType.KEY, Vector2i(3, 1), "fifth_floor_room_2", Vector2i(80, -16)),
		Item.new("Banana", Global.ItemType.FOOD, Vector2i(0, 1), "fifth_floor_room_2", Vector2i(500, -32), false, 'fridge'),
			
		# Service Shaft
		Item.new("Cigarettes", Global.ItemType.MEDICINE, Vector2i(6, 0), "service_shaft", Vector2i(92, -32)),
		
		# Maintenance Room
		Item.new("Service Key", Global.ItemType.KEY, Vector2i(2, 1), "maintenance_room", Vector2i(378, -27)),
	]
	
	locks = {
		"service_door_3": {"keys": ["Service Key", "Master Key"], "unlocked": false, "pickable": false},
		"service_door_4": {"keys": ["Service Key", "Master Key"], "unlocked": false, "pickable": false},
		"service_door_5": {"keys": ["Service Key", "Master Key"], "unlocked": false, "pickable": false},
		#"room_31": {"keys": ["Apartment 3-1 Key", "Master Key"], "unlocked": false, "pickable": true},
		"room_52": {"keys": ["Apartment 5-2 Key", "Master Key"], "unlocked": false, "pickable": true},
		"building_roof": {"keys": ["Master Key"], "unlocked": false, "pickable": false},
		"building_roof_area": {"keys": ["Master Key"], "unlocked": false, "pickable": false},
	}
	
	music = {
		"_default": "hallway",
		"third_floor_room_1": "room",
		"jelly_room": null,
		"fourth_floor_room_1": "room",
		"fourth_floor_room_2": "room",
		"fifth_floor_room_1": "room",
		"fifth_floor_room_2": "room",
		"fire_escape": null,
		"roof": "roof",
		"side_building": null,
		"end": null,
		"dead": null,
	}
	
	rain = {
		"jelly_room": {"outside": false, "lightning": false},
		"fire_escape": {"outside": true, "lightning": false},
		"roof": {"outside": true, "lightning": true},
		"side_building": {"outside": true, "lightning": false},
		"dead": {"outside": false, "lightning": false},
	}
	
	Global.audio.load_sfx("door_open")
	Global.audio.load_sfx("door_close")
	
	# Load start area
	change_area("jelly_room", Vector2(48, -34))
	#change_area("roof", Vector2(1300, -120))
		
	Global.player.show_speech_bubble(
		[
			"I want a\n Pink Drink!",
			"Waaaaaaaaaaaah!"
		], 
		2.5
	)
	


