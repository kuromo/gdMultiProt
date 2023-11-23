extends Area2D

var projSpeed = 50
var projRange = .7
var projPierce = 1
var projHits = 0

var projDmg = 60

func _physics_process(delta):
	position += transform.x * projSpeed * delta
	_selfDestruct()

func _selfDestruct():
	await get_tree().create_timer(projRange).timeout
	queue_free()



func _on_body_entered(body):
	print("entered body")
	if(body.is_in_group("enemies")):
		#last pierce hit, disable collison
		if(projHits == projPierce):
#			print("i hit a " +body.name + " was last pierce")
			body.onHit(projDmg)
			get_node("CollisionPolygon2D").set_deferred("disabled", true)
			self.hide()
		elif(projHits < projPierce):
#			print("i hit a " +body.name)
			body.onHit(projDmg)
			projHits += 1
	if(body.is_in_group("envoirement")):
		get_node("CollisionPolygon2D").set_deferred("disabled", true)
		self.hide()

