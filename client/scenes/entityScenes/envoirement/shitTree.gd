extends StaticBody2D

@export var hitParticles : PackedScene

func onHit():
	var particleInstance = hitParticles.instantiate()
	particleInstance.position = position
	owner.add_child(particleInstance)

