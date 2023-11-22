class_name RemapButton extends Button

signal actionRemapped(action, event)

@export var action: String

func _init():
	toggle_mode = true
	theme_type_variation = "RemapButton"

func _ready():
	set_process_unhandled_input(false)
	updateKeyText()

func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "waiting for input"
		release_focus()
	else:
		updateKeyText()
		grab_focus()


func _unhandled_input(event):
	if event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		actionRemapped.emit(action, event)


func updateKeyText():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()
