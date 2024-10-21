extends Control

func _ready():
	%ButtonStart.grab_focus()
	
func show_ui():
	visible = true
	%ButtonStart.grab_focus()
	
func hide_ui():
	visible = false

func _on_button_start_pressed():
	Global.player.reset()
	Global.game.reset()
	Global.game.change_level("apartment")

func _on_button_settings_pressed():
	Global.game.show_settings()

func _on_button_controls_pressed():
	Global.game.show_controls()

func _on_button_exit_pressed():
	get_tree().quit()

