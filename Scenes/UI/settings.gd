extends Control

@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sfx_bus = AudioServer.get_bus_index("SFX")
@onready var rain_bus = AudioServer.get_bus_index("Rain")


func _ready():
	%HSliderMusic.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	%HSliderSFX.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	%HSliderRain.value = db_to_linear(AudioServer.get_bus_volume_db(rain_bus))
	
func show_ui():
	visible = true
	%ButtonOk.grab_focus()
	
func hide_ui():
	visible = false

func _on_h_slider_music_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus, value < 0.05)

func _on_h_slider_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus, value < 0.05)
	
func _on_h_slider_rain_value_changed(value):
	AudioServer.set_bus_volume_db(rain_bus, linear_to_db(value))
	AudioServer.set_bus_mute(rain_bus, value < 0.05)
	
func _on_check_box_rain_toggled(toggled_on):
	Global.game.rain = toggled_on

func _on_button_ok_pressed():
	Global.game.hide_settings()

