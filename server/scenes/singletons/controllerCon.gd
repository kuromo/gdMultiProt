extends Node

var peer = ENetMultiplayerPeer.new()
var gatewayAPI = SceneMultiplayer.new()
var ip = "127.0.0.1"
var port = 33336

@onready var gameSrv = $"/root/server"


func _ready():
	connectServer()


func connectServer():
	print("connect to gameSrv controller")
	
	peer.create_client(ip, port)
	get_tree().set_multiplayer(gatewayAPI, self.get_path())
	multiplayer.set_multiplayer_peer(peer)

	multiplayer.connected_to_server.connect(_onConnectionSucceeded)
	multiplayer.connection_failed.connect(_onConnectionFailed)


func _onConnectionFailed():
	print("server controller connection failed")


func _onConnectionSucceeded():
	print("game server connected to server controller")
	
@rpc("any_peer")
func recieveToken(token):
	gameSrv.expectedTokens.append(token)
