class_name Audio

var sfx = {}
var music = {}
var last = {}
var rain = null
var rain_last = null

func play_rain():
	if rain == null:
		load_rain()
		
	if rain_last != null:
		rain.play(rain_last)
		
	rain.play()
		
func stop_rain():
	if rain:
		rain_last = rain.get_playback_position()
	
	rain.stop()

func load_rain():
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = &"Rain"
	audio_player.stream = load("res://Assets/Audio/rain.ogg")
	
	Global.game.add_child(audio_player)
	
	rain = audio_player

func play_music(name: String):	
	if not music.has(name):
		load_music(name)
	
	if name != "pink_drinker":
		stop_music(name)

	if music[name].playing:
		return
	
	if not last.has(name):
		last[name] = 0.0
	
	music[name].play(last[name])

func stop_music(name: String = ""):
	for existing_name in music:
		if existing_name != name and music[existing_name].playing:
			if existing_name != "pink_drinker":
				last[existing_name] = music[existing_name].get_playback_position()
			music[existing_name].stop()
	
func load_music(name: String):
	if music.has(name):
		return
		
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = &"Music"
	audio_player.stream = load("res://Assets/Audio/Music/" + name + ".ogg")
	
	Global.game.add_child(audio_player)
	
	music[name] = audio_player

func play_sfx(name: String, count: int = -1, rand: bool = false):
	if count != -1:
		if rand:
			var index: int
			
			while true:
				index = randi() % count + 1
				if not last.has(name) or last[name] != index:
					break
			
			last[name] = index	
			name += str(last[name])
		else:
			if not last.has(name) or last[name] == count:
				last[name] = 1
				name += "1"
			else:
				last[name] += 1
				name += str(last[name])
				
	if not sfx.has(name):
		load_sfx(name)
		
	sfx[name].play()
	
func load_sfx(name: String):
	if sfx.has(name):
		return
		
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = &"SFX"
	if ResourceLoader.exists("res://Assets/Audio/SFX/" + name + ".ogg"):
		audio_player.stream = load("res://Assets/Audio/SFX/" + name + ".ogg")
	else:
		audio_player.stream = load("res://Assets/Audio/SFX/" + name + ".wav")
	
	Global.game.add_child(audio_player)
	
	sfx[name] = audio_player
