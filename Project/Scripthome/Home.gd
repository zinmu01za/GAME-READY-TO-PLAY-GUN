extends Control

onready var settings_menu = $SettingsMenu


func _on_Button1_pressed():
	get_tree().change_scene("res://Scripthome/Home2.tscn")
	


func _on_Button3_pressed():
	get_tree().quit()


func _on_BTN_Settings_pressed():
	settings_menu.popup_centered()
