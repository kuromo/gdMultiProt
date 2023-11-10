extends Node

var peer = ENetMultiplayerPeer.new()
var port = 33333
var maxPlyers = 100


func _ready():
	startServer()
	
	
func startServer():
	peer.create_server(port, maxPlyers)
	multiplayer.multiplayer_peer = peer
	print("server up")
	
	peer.connect("peer_connected", _peerConnected)
	peer.connect("peer_disconnected", _peerDisconnected)

func _peerConnected(playerId):
	print(str(playerId) + " connected")
	
func _peerDisconnected(playerId):
	print(str(playerId) + " disconnected")
	
