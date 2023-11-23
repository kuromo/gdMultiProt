extends Node2D

@onready var ySortPivot = $ySortPivot
@onready var ySortPivot2 = $ySortPivot/ySortPivot2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("options"):
		print("options key pressed")
		$/root/sceneHandler.openSettings()
	elif event.is_action_pressed("escape"):
		print("escape key pressed")
		$/root/sceneHandler.openIngameMenu()

func propRot(rot):
	ySortPivot.rotation += rot
	ySortPivot2.rotation -= rot
	
#	print("Main rota")
#	print(rot)
	for node in get_tree().get_nodes_in_group("billboardRotation"):
		node.rotation += rot
	
