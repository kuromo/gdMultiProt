extends Control

@export var actionItems : Array[String]

@onready var musicVolSlider = %musicVolSlider
@onready var sfxVolSlider = %sfxVolSlider
@onready var inputGrid = %inputGrid
@onready var windowModeSelect = %windowModeSelect
var userSettings: UserSettings


func _ready():
	userSettings = UserSettings.loadOrCreate()
	if musicVolSlider:
		musicVolSlider.value = userSettings.musicVolume
	if sfxVolSlider:
		sfxVolSlider.value = userSettings.sfxVolume
	createActionRemapItem()
	populateWindowModes()
	
	
func populateWindowModes():
	var windowModes = {0: "Windowed", 3: "Windowed Fullscreen", 4: "Fullscreen"}
	for key in windowModes:
		windowModeSelect.add_item(windowModes[key], key)
	
	var selectedIndex = windowModeSelect.get_item_index(userSettings.windowMode)
	windowModeSelect.selected = selectedIndex
	
	


func _on_music_vol_slider_value_changed(value):
	if userSettings:
		userSettings.musicVolume = value
		userSettings.save()


func _on_sfx_vol_slider_value_changed(value):
		userSettings.sfxVolume = value
		userSettings.save()

func createActionRemapItem() -> void:
	for i in range(actionItems.size()):
		var action = actionItems[i]
		var label = Label.new()
		label.text = action
		inputGrid.add_child(label)
		
		var button = RemapButton.new()
		button.action = action
		
		if userSettings:
			if userSettings.actionEvents.has(action):
				var event = userSettings.actionEvents[action]
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action, event)
			button.actionRemapped.connect(_onActionRemapped)
		inputGrid.add_child(button)


func _onActionRemapped(action: String, event: InputEvent) -> void:
	if userSettings:
		userSettings.actionEvents[action] = event
		userSettings.save()


func _on_window_mode_select_item_selected(index):
	var selectedWindowMode = windowModeSelect.get_item_id(index)
	DisplayServer.window_set_mode(selectedWindowMode)
	if userSettings:
		userSettings.windowMode = selectedWindowMode
		userSettings.save()


func _on_close_button_pressed():
	$/root/sceneHandler.closeSettings()
