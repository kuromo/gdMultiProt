extends Node

var map = preload("res://scenes/mainScenes/map.tscn")
var loginScene = preload("res://scenes/ui/loginScreen.tscn")
var settings = preload("res://scenes/ui/settingsMenu.tscn")

@onready var settingsSplitter = $settingsSplitter

var userSettings: UserSettings


func _ready():
	userSettings = UserSettings.loadOrCreate()
	
	exexGraphicSettings()

	
#	var mapInstance = map.instantiate()
	var loginInstance = loginScene.instantiate()
	var settingsInstance = settings.instantiate()
	settingsSplitter.add_child(settingsInstance)
	settingsSplitter.add_child(loginInstance)
	closeSettings()


func exexGraphicSettings():
	DisplayServer.window_set_min_size(Vector2i(800,600))
	DisplayServer.window_set_mode(userSettings.windowMode)


func openSettings():
	print("open settings")
	print(settingsSplitter.collapsed)
	settingsSplitter.collapsed = false
	print(settingsSplitter.collapsed)
	settingsSplitter.get_child(0).visible = true
	
func closeSettings():
	print("close settings")
	print(settingsSplitter.collapsed)
	settingsSplitter.collapsed = true
	print(settingsSplitter.collapsed)
	settingsSplitter.get_child(0).visible = false

func userVerified():
#	var mapInstance = map.instantiate()
	print("user verification on gameserver succeeded, open some other scene")
