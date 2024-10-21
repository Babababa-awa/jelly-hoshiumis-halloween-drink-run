extends Control

func show_ui():
	visible = true
	%ButtonContinue.grab_focus()
	
func hide_ui():
	visible = false

func _on_button_continue_pressed():
	Global.game.toggle_pause()

func _on_button_settings_pressed():
	Global.game.show_settings()

func _on_button_menu_pressed():
	Global.game.goto_menu()

func _on_button_controls_pressed():
	Global.game.show_controls()
