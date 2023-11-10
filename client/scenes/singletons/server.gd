extends Node

var peer = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 33333

func _ready():
	connectServer()
	
	
func connectServer():

	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	
	peer.connect("connection_failed", _onConnectionFailed)
	peer.connect("connection_succeeded", _onConnectionSucceeded)


func _onConnectionFailed():
	print("client cant connect")
	
func _onConnectionSucceeded():
	print("client connected to server")
	
