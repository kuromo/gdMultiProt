extends Node

var worldState = {}

func _physics_process(delta):
	if !get_parent().playerStateCollection.is_empty():
		var playerState = get_parent().playerStateCollection.duplicate(true)
		for player in playerState.keys():
			playerState[player].erase("T")
		worldState["T"] = Time.get_unix_time_from_system()
		worldState["players"] = playerState
		worldState["enemies"] = %map.enemyList
		# logic can go here (verify, anti cheat, chuncking...)
		get_parent().updateWorldState(worldState)
