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
func requestLogin(usrMail, usrPwd):
	print("login request recieved from: " + str(multiplayer.get_remote_sender_id()))
	print("usr: " +usrMail +", pwd: " +usrPwd)
	var usrId = multiplayer.get_remote_sender_id()
	Authenticate.authUser(usrMail, usrPwd, usrId)

@rpc("any_peer")
func returnLoginReq(result, usrId, token):
	print("usr: " + str(usrId) + " login was " + str(result))
	rpc_id(usrId, "returnLoginReq", result, token)
	
#	TODO fix ugly ass timeout maybe? problem: rpc call gets deleted if client is disconnected before networkframe finishes
	await get_tree().create_timer(0.1).timeout
	peer.disconnect_peer(usrId)


@rpc("any_peer")
func requestCreateAcc(usrMail, usrPwd, usrName):
	print(usrMail +" requested an account")
	var usrId = multiplayer.get_remote_sender_id()
	var validRequest = true
	if usrMail == "":
		validRequest = false
	if usrPwd == "":
		validRequest = false
	if usrName == "":
		validRequest = false
#	if usrPwd.length() < 6:
#		validRequest = false

	if validRequest == false:
		returnCreateAcc(validRequest, usrId, 1)
	else:
		Authenticate.createAccount(usrMail, usrPwd, usrName, usrId)

@rpc("any_peer")
func returnCreateAcc(result, usrId, message):
	#messages= 1: failed check, 2: email taken, 3: username taken, 4: success
	rpc_id(usrId, "returnCreateAcc", result, message)
	
#	TODO fix ugly ass timeout maybe? problem: rpc call gets deleted if client is disconnected before networkframe finishes
	await get_tree().create_timer(0.1).timeout
	peer.disconnect_peer(usrId)
