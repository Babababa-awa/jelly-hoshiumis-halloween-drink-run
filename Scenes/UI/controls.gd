extends Control

func show_ui():
	visible = true
	%ButtonOk.grab_focus()
	
func hide_ui():
	visible = false

func _on_button_ok_pressed():
	Global.game.hide_controls()
