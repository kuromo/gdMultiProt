extends Node

var peer = ENetMultiplayerPeer.new()
var port = 33334
var maxServers = 5


func _ready():
	startServer()
	
	
func startServer():
	peer.create_server(port, maxServers)
	multiplayer.multiplayer_peer = peer
	print("auth server up")
	
	peer.connect("peer_connected", _peerConnected)
	peer.connect("peer_disconnected", _peerDisconnected)

func _peerConnected(gatewayId):
	print("gateway " + str(gatewayId) + " connected")
	
func _peerDisconnected(gatewayId):
	print("gateway " + str(gatewayId) + " disconnected")
	
@rpc("any_peer")
func authPlayer(usrName, usrPwd, usrId):
	var gatewayId = multiplayer.get_remote_sender_id()
	var result
	if(!usrData.users.has(usrName)):
		print ("usr not found")
		result = false
	elif(usrData.users[usrName].pwd != usrPwd):
		print ("wrong pwd")
		result = false
	else:
		print("auth tsuccessful")
		result = true
	print("auth results sent to gw")
	rpc_id(gatewayId, "authResults", result, usrId)
	
	
@rpc("any_peer")
func authResults(result, usrId):
	pass	
