extends Node

var peer = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 33333

var token

func _ready():
	pass
#	connectServer()
	
	
func connectServer():
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(_onConnectionSucceeded)
	multiplayer.connection_failed.connect(_onConnectionFailed)


func _onConnectionFailed():
	print("client cant connect")
	
func _onConnectionSucceeded():
	print("client connected to server")


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
