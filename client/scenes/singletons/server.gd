extends Node

var peer = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 33333

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
	
