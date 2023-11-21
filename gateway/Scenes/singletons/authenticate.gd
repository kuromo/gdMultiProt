extends Node

var peer = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 33334

func _ready():
	connectServer()
	
	
func connectServer():

	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_onConnectionSucceeded)
	multiplayer.connection_failed.connect(_onConnectionFailed)


func _onConnectionFailed():
	print("gateway cant connect auth")
	
func _onConnectionSucceeded():
	print("gateway connected to auth server")
	
@rpc("any_peer")
func authPlayer(usrName, usrPwd, usrId):
	rpc_id(1, "authPlayer", usrName, usrPwd, usrId)
	
@rpc("any_peer")
func authResults(result, usrId, token):
	Gateway.returnLoginReq(result, usrId, token)
