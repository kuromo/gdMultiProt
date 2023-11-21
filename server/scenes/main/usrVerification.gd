extends Node

var awaitingVerification = {}
@onready var mainInterface = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start(usrId):
	awaitingVerification[usrId] = {"timestamp": Time.get_unix_time_from_system()}
	mainInterface.fetchToken(usrId)

func verify(usrId, token):
	var tokenVerification = false
	var tokenTimeDif = int(Time.get_unix_time_from_system()) - int(token.right(-64))
	# check if token is not older than 30s and not from a too tfar future
	while(tokenTimeDif <= 30 && tokenTimeDif > -600):
		if mainInterface.expectedTokens.has(token):
			tokenVerification = true
			print("verification successfull")
			awaitingVerification.erase(usrId)
			mainInterface.expectedTokens.erase(token)
			break
		else:
			await get_tree().create_timer(2).timeout
	mainInterface.returnTokenVeriResults(usrId, tokenVerification)
	if tokenVerification == false:
		awaitingVerification.erase(usrId)
		#	TODO fix ugly ass timeout maybe? problem: rpc call gets deleted if client is disconnected before networkframe finishes
		await get_tree().create_timer(0.1).timeout
		mainInterface.peer.disconnect_peer(usrId)


func _on_verification_expiration_timeout():
	var currentTime = int(Time.get_unix_time_from_system())
	var startTime
	if awaitingVerification == {}:
		pass
	else:
		for key in awaitingVerification.keys():
			startTime = int(awaitingVerification[key].timestamp)
			if currentTime - startTime > 30:
				awaitingVerification.erase(key)
				var connectedPeers = Array(multiplayer.get_peers())
				if connectedPeers.has(key):
					mainInterface.returnTokenVeriResults(key, false)
					#	TODO fix ugly ass timeout maybe? problem: rpc call gets deleted if client is disconnected before networkframe finishes
					await get_tree().create_timer(0.1).timeout
					mainInterface.peer.disconnect_peer(key)
	print("users awaiting verification: ")
	print(awaitingVerification)

	
	
