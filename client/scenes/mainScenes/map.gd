extends Node2D

@onready var ySortPivot = $ySortPivot
@onready var ySortPivot2 = $ySortPivot/ySortPivot2

var playerTemplate = preload("res://scenes/entityScenes/playerTemplate.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("options"):
		print("options key pressed")
		$/root/sceneHandler.toggleSettings()
	elif event.is_action_pressed("escape"):
		print("escape key pressed")
		$/root/sceneHandler.toggleIngameMenu()

func propRot(rot):
	ySortPivot.rotation += rot
	ySortPivot2.rotation -= rot
	
	for node in get_tree().get_nodes_in_group("billboardRotation"):
		node.rotation += rot
	
@rpc("any_peer")
func spawnPlayer(usrId, spawnPos):
	print("spawn player:")
	print(usrId)
	if multiplayer.get_unique_id() == usrId:
		print("is self")
		pass
	else:
		var newPlayer = playerTemplate.instantiate()
		newPlayer.position = spawnPos
		newPlayer.name = str(usrId)
		%otherPlayers.add_child(newPlayer)

@rpc("any_peer")
func despawnPlayer(usrId):
	print("despawn player:")
	print(usrId)
	%otherPlayers.get_node(str(usrId)).queue_free()
