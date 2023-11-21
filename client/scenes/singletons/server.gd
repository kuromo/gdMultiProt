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
		$"../sceneHandler/map/loginScreen".queue_free()
		print("successful token verification")
	else:
		print("token verification failed")
		$"../sceneHandler/map/loginScreen/base/margin/vBox/loginButton".disabled = false
