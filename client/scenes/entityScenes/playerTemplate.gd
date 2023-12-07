extends CharacterBody2D

@onready var aniTree = get_node("playerAniTree")
@onready var aniMode = aniTree.get("parameters/playback")

var proj = preload("res://scenes/entityScenes/projectile.tscn")

var attackDict = {} # [spawnTime] = {"position" = position, "animationVector" = animationVector}
var state = "Idle"



func _physics_process(delta):
	if !attackDict == {}:
		attack()

func movePlayer(newPos, animationVector):
	aniTree.set("parameters/Walk/blend_position", animationVector)
	aniTree.set("parameters/Idle/blend_position", animationVector)
	if !state == "Attack":

		print("move other player vector: ",animationVector)
		if newPos == position:
			print("idle")
			aniMode.travel("Idle")
		else:
			print("walk")
			aniMode.travel("Walk")

	position = newPos
			


func attack():
	for attack in attackDict.keys():
		# subtract 100ms as movement is rendered the same way, due to interpolation buffer
		if attack <= server.clientClock - 0.1:
			state = "Attack"
			aniTree.set("parameters/Attack/blend_position", attackDict[attack]["animationVector"])
			aniTree.set("parameters/Idle/blend_position", attackDict[attack]["animationVector"])
			aniMode.travel("Attack")
			
			# TODO check if set position is nescessary
			position = attackDict[attack]["position"]
			
			var fireAngle = get_angle_to(position + attackDict[attack]["animationVector"])
			get_node("projAxis").rotation = fireAngle
			var projInst = proj.instantiate()
			projInst.position = get_node("projAxis/projSpawn").get_global_position()
			projInst.rotation = fireAngle + rotation
			projInst.original = false
			attackDict.erase(attack)
			get_parent().add_child(projInst)
			
			#TODO sync to rof/snimation time
			await get_tree().create_timer(.3).timeout
			state = "Idle"
