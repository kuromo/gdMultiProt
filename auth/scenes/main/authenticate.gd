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
func authUser(usrMail, usrPwd, usrId):
	var gatewayId = multiplayer.get_remote_sender_id()
	var result
	var token
	if(!usrData.users.has(usrMail)):
		print ("usr not found")
		result = false
	elif(usrData.users[usrMail].pwd != usrPwd):
		print ("wrong pwd")
		result = false
	else:
		print("auth tsuccessful")
		result = true
		
		#randomize random generator, token = hashed random int + unix timestamp int
		randomize()
		token = str(randi()).sha256_text() + str(int(Time.get_unix_time_from_system()))
		var tmpSrvName = "gameSrv1"
		gameServers.distLoginToken(token, tmpSrvName)
		
	print("auth results sent to gw")
	rpc_id(gatewayId, "authResults", result, usrId, token)
	
	
@rpc("any_peer")
func authResults(result, usrId):
	pass	

@rpc("any_peer")
func createAccount(usrMail, usrPwd, usrName, usrId):
	var gatewayId = multiplayer.get_remote_sender_id()
	var result
	var message
	if(usrData.users.has(usrMail)):
		result = false
		message = 2
	else:
		var nameTaken = false
		for key in usrData.users.keys():
			if usrData.users[key].usrName == usrName:
				nameTaken = true
				break
		if nameTaken == true:
			result = false
			message = 3
		else:
			result = true
			message = 4
			usrData.users[usrMail] = {"usrName": usrName, "pwd": usrPwd}
			usrData.saveUsrAcc()
	
	rpc_id(gatewayId, "createAccountResults", result, usrId, message)

@rpc("any_peer")
func createAccountResults():
	pass
