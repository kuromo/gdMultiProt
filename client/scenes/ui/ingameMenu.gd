extends Control




func _on_return_button_pressed():
	$/root/sceneHandler.closeIngameMenu()


func _on_settings_button_pressed():
	$/root/sceneHandler.openSettings()


func _on_close_button_pressed():
	$/root/sceneHandler.closeApp()
