extends Node

var peer = ENetMultiplayerPeer.new()
var port = 33333
var maxPlyers = 100

var expectedTokens = []

@onready var usrVeri = $usrVerification

#TESTING skip token verification
var skipToken = true


func _ready():
	startServer()
	
	
func startServer():
	peer.create_server(port, maxPlyers)
	multiplayer.multiplayer_peer = peer
	print("server up")
	
	peer.connect("peer_connected", _peerConnected)
	peer.connect("peer_disconnected", _peerDisconnected)

func _peerConnected(usrId):
	print(str(usrId) + " connected")
	#TESTING skip token verification
	if skipToken:
		usrVeri.createUsrContainer(usrId)
		returnTokenVeriResults(usrId, true)
	else:
		usrVeri.start(usrId)
	
func _peerDisconnected(usrId):
	print(str(usrId) + " disconnected")
	get_node(str(usrId)).queue_free()
	rpc_id(0, "despawnPlayer", usrId)


func _on_tokenExpiration_timeout():
	if(expectedTokens == []):
		pass
	else:
		var currentTime = int(Time.get_unix_time_from_system())
		for i in range(expectedTokens.size() -1, -1, -1):
			var tokenTime = int(expectedTokens[i].right(-64))
			if(currentTime - tokenTime > 30):
				expectedTokens.remove_at(i)
	print("expected tokens")
	print(expectedTokens)


@rpc("any_peer")
func fetchToken(usrId):
	print("call fetch token on client")
	rpc_id(usrId, "fetchToken")

@rpc("any_peer")
func returnToken(token):
	var usrId = multiplayer.get_remote_sender_id()
	usrVeri.verify(usrId, token)

@rpc("any_peer")
func returnTokenVeriResults(usrId, result):
	print("server return token result: " + str(result) + " for user: ")
	print(usrId)
	rpc_id(usrId, "returnTokenVeriResults", result)
	if result == true:
		rpc_id(0, "spawnPlayer", usrId, Vector2(300, 250))

@rpc("any_peer")
func spawnPlayer():
	pass
	
@rpc("any_peer")
func despawnPlayer():
	pass
