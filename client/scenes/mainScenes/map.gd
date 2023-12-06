extends Node2D

@onready var ySortPivot = $ySortPivot
@onready var ySortPivot2 = $ySortPivot/ySortPivot2

var playerTemplate = preload("res://scenes/entityScenes/playerTemplate.tscn")
var enemyTemplate = preload("res://scenes/entityScenes/herbert.tscn")

var lastWorldState = 0
var worldStateBuffer = [] # states: [pastPast, past, future, ..anyFurtherFuture]
var interpolationOffset = 0.1

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
		if !%otherPlayers.has_node(str(usrId)):
			var newPlayer = playerTemplate.instantiate()
			newPlayer.position = spawnPos
			newPlayer.name = str(usrId)
			%otherPlayers.add_child(newPlayer)

@rpc("any_peer")
func despawnPlayer(usrId):
	
	# TODO maybe add logout timer on server https://youtu.be/XGyrKmOxLcc?si=rOgmwTxE2Ljm3PDm&t=659
	# TODO change timeout to better solution if possible
	await get_tree().create_timer(0.2).timeout
	%otherPlayers.get_node(str(usrId)).queue_free()


func spawnNewEnemy(enemyId, enemyDict):
	var newEnemy = enemyTemplate.instantiate()
	print(enemyDict)
	newEnemy.position = enemyDict["location"]
	newEnemy.maxHealth = enemyDict["maxHealth"]
	newEnemy.currentHealth = enemyDict["health"]
	newEnemy.type = enemyDict["type"]
	newEnemy.state = enemyDict["state"]
	newEnemy.name = str(enemyId)
	%enemies.add_child(newEnemy)

func updateWorldState(worldState):
	if worldState["T"] > lastWorldState:
		lastWorldState = worldState["T"]
		worldStateBuffer.append(worldState)


func _physics_process(delta):
#	var renderTime = Time.get_unix_time_from_system() - interpolationOffset
	var renderTime = server.clientClock - interpolationOffset
	if worldStateBuffer.size() > 1:
		while worldStateBuffer.size() > 2 and renderTime > worldStateBuffer[2]["T"]:
			worldStateBuffer.remove_at(0)
			
		if worldStateBuffer.size() > 2: # we have a future state
			var interpolationFactor = (renderTime - worldStateBuffer[1]["T"]) / (worldStateBuffer[2]["T"] - worldStateBuffer[1]["T"])
			for player in worldStateBuffer[2]["players"].keys():
				if str(player) == "T":
					continue
				if str(player) == "enemies":
					continue
				if player == multiplayer.get_unique_id():
					continue
				if !worldStateBuffer[1]["players"].has(player):
					continue
				if %otherPlayers.has_node(str(player)):
					var newPos = lerp(worldStateBuffer[1]["players"][player]["P"], worldStateBuffer[2]["players"][player]["P"], interpolationFactor)
					%otherPlayers.get_node(str(player)).movePlayer(newPos)
				else:
					print("worldstate spawn player")
					spawnPlayer(player, worldStateBuffer[2]["players"][player]["P"])
			for enemy in worldStateBuffer[2]["enemies"].keys():
				if !worldStateBuffer[1]["enemies"].has(enemy):
					continue
				if %enemies.has_node(str(enemy)):
					var newPos = lerp(worldStateBuffer[1]["enemies"][enemy]["location"], worldStateBuffer[2]["enemies"][enemy]["location"], interpolationFactor)
					%enemies.get_node(str(enemy)).moveEnemy(newPos)
					%enemies.get_node(str(enemy)).updateHealth(worldStateBuffer[1]["enemies"][enemy]["health"])
				else:
					spawnNewEnemy(enemy, worldStateBuffer[2]["enemies"][enemy])
		elif renderTime > worldStateBuffer[1]["T"]: # no future state
			var extrapolationFactor = (renderTime - worldStateBuffer[0]["T"]) / (worldStateBuffer[1]["T"] - worldStateBuffer[0]["T"]) - 1.0
			for player in worldStateBuffer[1]["players"].keys():
				if str(player) == "T":
					continue
				if str(player) == "enemies":
					continue
				if player == multiplayer.get_unique_id():
					continue
				if !worldStateBuffer[0]["players"].has(player):
					continue
				if %otherPlayers.has_node(str(player)):
					var posDelta = worldStateBuffer[1]["players"][player]["P"] - worldStateBuffer[0]["players"][player]["P"]
					var newPos = worldStateBuffer[1]["players"][player]["P"] + (posDelta * extrapolationFactor)
					%otherPlayers.get_node(str(player)).movePlayer(newPos)
