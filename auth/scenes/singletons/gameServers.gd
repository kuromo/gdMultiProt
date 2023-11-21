extends Node


var peer = ENetMultiplayerPeer.new()
var gatewayAPI = SceneMultiplayer.new()
var port = 33336
var maxPlayers = 100

var gameSrvList = {}

func _ready():
	startServer()
	
	
func startServer():
	print("gameserver controll up")
	peer.create_server(port, maxPlayers)
	get_tree().set_multiplayer(gatewayAPI, self.get_path())
	multiplayer.set_multiplayer_peer(peer)

	peer.connect("peer_connected", _peerConnected)
	peer.connect("peer_disconnected", _peerDisconnected)

func _peerConnected(gameSrvId):
	print("gameserver " + str(gameSrvId) + " connected")
	gameSrvList["gameSrv1"] = gameSrvId
	
func _peerDisconnected(gameSrvId):
	print("gameserver " + str(gameSrvId) + " disconnected")

func distLoginToken(token, gameSrv):
	print("Token for " + gameSrv  +" is: " + token)
	var gameSrvId = gameSrvList[gameSrv]
	rpc_id(gameSrvId, "recieveToken", token)
	
@rpc("any_peer")
func recieveToken(token):
	pass
