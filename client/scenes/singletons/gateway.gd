extends Node

var peer = ENetMultiplayerPeer.new()
var gatewayAPI = SceneMultiplayer.new()
var ip = "127.0.0.1"
var port = 33335

var usrMail
var usrName
var usrPwd
var newAcc = false


func connectServer(_usrMail, _usrPwd, _newAcc, _usrName=""):
	print("gw connectSrv")
	
	usrMail = _usrMail
	usrPwd = _usrPwd
	usrName = _usrName
	newAcc = _newAcc
	
	peer.create_client(ip, port)
	get_tree().set_multiplayer(gatewayAPI, self.get_path())
	multiplayer.set_multiplayer_peer(peer)

	
	multiplayer.connected_to_server.connect(_onConnectionSucceeded)
	multiplayer.connection_failed.connect(_onConnectionFailed)


func _onConnectionFailed():
	#TODO error
	print("gw connection failed")
	$"../sceneHandler/map/loginScreenn".loginBtn.disabled = false
	$"../sceneHandler/map/loginScreenn".createBtn.disabled = false
	$"../sceneHandler/map/loginScreen".createConfBtn.disabled = false
	$"../sceneHandler/map/loginScreen".createBackBtn.disabled = false
	multiplayer.connected_to_server.disconnect(_onConnectionSucceeded)
	multiplayer.connection_failed.disconnect(_onConnectionFailed)
	
func _onConnectionSucceeded():
	print("connected to gw")
	print(multiplayer.get_unique_id())
	if newAcc == true:
		requestCreateAcc()
	else:
		requestLogin()

@rpc("any_peer")
func requestLogin():
	print("request login from gateway")
	rpc_id(1, "requestLogin", usrMail, usrPwd)
	usrMail = ""
	usrPwd = ""

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
		$"../sceneHandler/map/loginScreenn".loginBtn.disabled = false
		$"../sceneHandler/map/loginScreenn".createBtn.disabled = false
	multiplayer.connected_to_server.disconnect(_onConnectionSucceeded)
	multiplayer.connection_failed.disconnect(_onConnectionFailed)

@rpc("any_peer")
func requestCreateAcc():
	print("request account on gw")
	rpc_id(1, "requestCreateAcc", usrMail, usrPwd, usrName)
	usrMail = ""
	usrPwd = ""
	usrName = ""

@rpc("any_peer")
func returnCreateAcc(result, message):
	#messages= 1: failed check, 2: email taken, 3: username taken, 4: success
	if result == true:
		print("account created, you can log in now")
		get_node("../sceneHandler/map/loginScreen")._on_back_button_pressed()
	else:
		if message == 1:
			print("account creation failed, try again")
		elif message == 2:
			print("email is taken, use a diffrent one or log in")
		elif message == 3:
			print("username is taken")
		$"../sceneHandler/map/loginScreen".createConfBtn.disabled = false
		$"../sceneHandler/map/loginScreen".createBackBtn.disabled = false
	multiplayer.connected_to_server.disconnect(_onConnectionSucceeded)
	multiplayer.connection_failed.disconnect(_onConnectionFailed)
		
