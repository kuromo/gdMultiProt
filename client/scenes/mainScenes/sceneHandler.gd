extends Node

var map = preload("res://scenes/mainScenes/map.tscn")
var loginScene = preload("res://scenes/ui/loginScreen.tscn")
var settings = preload("res://scenes/ui/settingsMenu.tscn")
var ingameMenu = preload("res://scenes/ui/ingameMenu.tscn")

@onready var settingsSplitter = $settingsSplitter
var ingameMenuSplitter

var userSettings: UserSettings

#TESTING if true skip login
var skipLogin = true

func _ready():
	userSettings = UserSettings.loadOrCreate()
	
	exexGraphicSettings()

	var loginInstance = loginScene.instantiate()
	var settingsInstance = settings.instantiate()
	settingsSplitter.add_child(settingsInstance)
	settingsSplitter.add_child(loginInstance)
	closeSettings()


func exexGraphicSettings():
	DisplayServer.window_set_min_size(Vector2i(800,600))
	DisplayServer.window_set_mode(userSettings.windowMode)


func openSettings():
	settingsSplitter.collapsed = false
	settingsSplitter.get_child(0).visible = true
	
func closeSettings():
	settingsSplitter.collapsed = true
	settingsSplitter.get_child(0).visible = false
	
func openIngameMenu():
	if ingameMenuSplitter:
		print("open ign has splitter")
		ingameMenuSplitter.collapsed = false
	
func closeIngameMenu():
	if ingameMenuSplitter:
		ingameMenuSplitter.collapsed = true

func userVerified():
	var mapInstance = map.instantiate()
	createGameContainer(mapInstance)

func createGameContainer(instance):
	
	var mapInstance = map.instantiate()
	var vpContInstance = SubViewportContainer.new()
	vpContInstance.stretch = true
	var vpInstance = SubViewport.new()
	vpInstance.add_child(mapInstance)
	vpContInstance.add_child(vpInstance)
	$settingsSplitter/loginScreen.queue_free()

	
	
	var vSplit = VSplitContainer.new()
	vSplit.split_offset = 80
	vSplit.collapsed = true
	vSplit.dragger_visibility = vSplit.DRAGGER_HIDDEN_COLLAPSED
	vSplit.add_child(ingameMenu.instantiate())
	vSplit.add_child(vpContInstance)
	
	ingameMenuSplitter = vSplit
	settingsSplitter.add_child(vSplit)

	
	
