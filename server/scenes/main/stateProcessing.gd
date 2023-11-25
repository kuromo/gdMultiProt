extends Node

var worldState


func _physics_process(delta):
	if !get_parent().playerStateCollection.is_empty():
		worldState = get_parent().playerStateCollection.duplicate(true)
		for player in worldState.keys():
			worldState[player].erase("T")
		worldState["T"] = Time.get_unix_time_from_system()
		# logic can go here (verify, anti cheat, chuncking...)
		get_parent().updateWorldState(worldState)
