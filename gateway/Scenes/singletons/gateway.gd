extends Node

var peer = ENetMultiplayerPeer.new()
var gatewayAPI = SceneMultiplayer.new()
var port = 33335
var maxPlayers = 100

func _ready():
	startServer()
	
	
func startServer():
	print("gateway server up")
	peer.create_server(port, maxPlayers)
	get_tree().set_multiplayer(gatewayAPI, self.get_path())
	multiplayer.set_multiplayer_peer(peer)

	peer.connect("peer_connected", _peerConnected)
	peer.connect("peer_disconnected", _peerDisconnected)

func _peerConnected(gatewayId):
	print("user " + str(gatewayId) + " connected to gw")
	
func _peerDisconnected(gatewayId):
	print("user " + str(gatewayId) + " disconnected")

@rpc("any_peer")
func loginReq(usrName, usrPwd):
	print("login request recieved from: " + str(multiplayer.get_remote_sender_id()))
	print("usr: " +usrName +", pwd: " +usrPwd)
	var usrId = multiplayer.get_remote_sender_id()
	Authenticate.authPlayer(usrName, usrPwd, usrId)

@rpc("any_peer")
func returnLoginReq(result, usrId):
	print("usr: " + str(usrId) + " login was " + str(result))
	rpc_id(usrId, "returnLoginReq", result)
	
	await get_tree().create_timer(0.1).timeout
	peer.disconnect_peer(usrId)
