extends Node

var peer = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 33333
var token

var clientClock = 0
var decimalCollector : float = 0
var latencyArray = []
var latency = 0
var deltaLatency = 0

func _physics_process(delta):
	clientClock += delta + deltaLatency
	deltaLatency = 0
	
	
func connectServer():
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(_onConnectionSucceeded)
	multiplayer.connection_failed.connect(_onConnectionFailed)


func _onConnectionFailed():
	print("client cant connect")
	
func _onConnectionSucceeded():
	print("client connected to server")
	fetchServerTime()
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", determineLatency)
	add_child(timer)
	

@rpc("any_peer")
func fetchServerTime():
	rpc_id(1, "fetchServerTime", Time.get_unix_time_from_system())
	
@rpc("any_peer")
func returnServerTime(serverTime, clientTime):
	latency = (Time.get_unix_time_from_system() - clientTime) / 2
	clientClock = serverTime + latency

@rpc("any_peer")
func determineLatency():
	rpc_id(1, "determineLatency", Time.get_unix_time_from_system())

@rpc("any_peer")
func returnLatency(serverTime, clientTime):
#	
	latencyArray.append((Time.get_unix_time_from_system() - clientTime) / 2)
	if latencyArray.size() == 9:
		var totalLatency = 0
		latencyArray.sort()
		var midPoint = latencyArray[4]
		for i in range(latencyArray.size()-1, -1, -1):
			if latencyArray[i] > (2 * midPoint) and latencyArray[i] > 20:
				latencyArray.remove_at(i)
			else:
				totalLatency += latencyArray[i]
		deltaLatency = (totalLatency / latencyArray.size()) - latency
		latency = totalLatency / latencyArray.size()
		print("new latency " + str(latency) + "  in ms: " + str((latency * 1000)))
		print("latency delta " + str(deltaLatency) + "  in ms: " + str((deltaLatency * 1000)))
		latencyArray.clear()
	# resync to server time
	clientClock = serverTime + latency

@rpc("any_peer")
func fetchToken():
	rpc_id(1, "returnToken", token)

@rpc("any_peer")
func returnToken():
	pass

@rpc("any_peer")
func returnTokenVeriResults(result):
	if(result == true):
#		$"../sceneHandler/map/loginScreen".queue_free()
		print("successful token verification")
		$/root/sceneHandler.userVerified()
	else:
		print("token verification failed")
		$"../sceneHandler/settingsSplitter/loginScreen".loginBtn.disabled = false
		$"../sceneHandler/settingsSplitter/loginScreen".createBtn.disabled = false

@rpc("unreliable")
func updatePlayerState(playerState):
	rpc_id(1, "updatePlayerState", playerState)
	
@rpc("any_peer")
func updateWorldState(worldState):
	var loadedMap = $/root/sceneHandler.loadedMap
	if loadedMap:
		loadedMap.updateWorldState(worldState)
		
#		print("wst: ", worldState["T"],"   cc: ", clientClock, "   worldDif:  " ,worldState["T"] - clientClock)

@rpc("any_peer")
func spawnPlayer(usrId, spawnPos):
	var loadedMap = $/root/sceneHandler.loadedMap
	if loadedMap:
		loadedMap.spawnPlayer(usrId, spawnPos)
	
@rpc("any_peer")
func despawnPlayer(usrId):
	var loadedMap = $/root/sceneHandler.loadedMap
	if loadedMap:
		loadedMap.despawnPlayer(usrId)
