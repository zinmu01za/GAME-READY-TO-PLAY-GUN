extends Popup

# Video Settings
onready var DisplayOptions = $SettingTabs/Video/MarginContainer/Videosettings/DisplayFpsBtn 
onready var VsyncBtn = $SettingTabs/Video/MarginContainer/Videosettings/VsyncBtn
onready var DisplayFpsBtn = $SettingTabs/Video/MarginContainer/Videosettings/DisplayFpsBtn

# Audio Settings
onready var MastervolSlider = $SettingTabs/Audio/MarginContainer/AudioSettings/MastervolSlider
onready var MusicvolSlider = $SettingTabs/Audio/MarginContainer/AudioSettings/MusicvolSlider



func _ready():
	pass
	


func _on_DisplayOptionButton_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)
	


func _on_VsyncBtn_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)



func _on_DisplayFpsBtn_toggled(button_pressed):
	GlobalSettings.toggle_fps_display(button_pressed)



func _on_BloomBtn_toggled(button_pressed):
	GlobalSettings.toggle_bloom(button_pressed)


	
	
func _on_BrightnessSlider_value_changed(value):
	GlobalSettings.update_brightness(value)


func _on_MastervolSlider_value_changed(value):
	GlobalSettings.update_Master_vol(value)


func _on_MusicvolSlider_value_changed(value):
	GlobalSettings.update_Master_vol(value)

	
