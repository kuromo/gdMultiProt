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
func authUser(usrMail, usrPwd, usrId):
	rpc_id(1, "authUser", usrMail, usrPwd, usrId)
	
@rpc("any_peer")
func authResults(result, usrId, token):
	Gateway.returnLoginReq(result, usrId, token)

@rpc("any_peer")
func createAccount(usrMail, usrPwd, usrName, usrId):
	print("sending create acc request")
	rpc_id(1, "createAccount", usrMail, usrPwd, usrName, usrId)

@rpc("any_peer")
func createAccountResults(result, usrId, message):
	Gateway.returnCreateAcc(result, usrId, message)
