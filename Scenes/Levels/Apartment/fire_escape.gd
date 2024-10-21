extends Node2D

var song_started: bool = false
var song_delta: float = 0.0

func _ready():
	Global.player.show_speech_bubble(
		[
			"Almost there!",
		], 
		3
	)

func _process(delta):
	if song_started:
		song_delta += delta
		
		if song_delta > 62:
			var parent = get_parent()
			parent.change_area("end", Vector2(0, 0), Global.PlayerMode.NONE)

func _on_area_song_start_body_entered(body):	
	if body.is_in_group("player"):
		song_started = true
		Global.audio.play_music("pink_drinker")
