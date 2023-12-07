extends Area2D

var projSpeed = 50
var projRange = .7
var projPierce = 1
var projHits = 0

var projDmg = 60

var original = true

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
			get_node("CollisionPolygon2D").set_deferred("disabled", true)
			self.hide()
			if original:
				body.onHit(projDmg)
		elif(projHits < projPierce):
#			print("i hit a " +body.name)
			projHits += 1
			if original:
				body.onHit(projDmg)
	if(body.is_in_group("envoirement")):
		body.onHit()
		get_node("CollisionPolygon2D").set_deferred("disabled", true)
		self.hide()

