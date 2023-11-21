extends Node

var peer = ENetMultiplayerPeer.new()
var gatewayAPI = SceneMultiplayer.new()
var ip = "127.0.0.1"
var port = 33335

var username
var password

func _ready():
	pass
	
	
func connectServer(_usrName, _usrPwd):
	print("gw connectSrv")
	username = _usrName
	password = _usrPwd
	
	peer.create_client(ip, port)
	get_tree().set_multiplayer(gatewayAPI, self.get_path())
	multiplayer.set_multiplayer_peer(peer)

	
	multiplayer.connected_to_server.connect(_onConnectionSucceeded)
	multiplayer.connection_failed.connect(_onConnectionFailed)


func _onConnectionFailed():
	#TODO error
	print("authSrv connection failed")
	$"../sceneHandler/map/loginScreen/base/margin/vBox/loginButton".disabled = false
	
func _onConnectionSucceeded():
	print("connected to authSrv")
	print(multiplayer.get_unique_id())
	requestLogin()
	
func requestLogin():
	print("request login from gateway")
	rpc_id(1, "loginReq", username, password)
	username = ""
	password = ""

@rpc("any_peer")
func loginReq(usr, pwd):
	pass
	
@rpc("any_peer")
func returnLoginReq(result, token):
	print("ret login")
	if(result):
		print("good login, connect to game server")
		print("token: " + token)
		server.token = token
		server.connectServer()
	else:
		print("bad login")
		$"../sceneHandler/map/loginScreen/base/margin/vBox/loginButton".disabled = false
	multiplayer.connected_to_server.disconnect(_onConnectionSucceeded)
	multiplayer.connection_failed.disconnect(_onConnectionFailed)
