extends CharacterBody2D

@onready var hpCopmonent = get_node("healthComponent")

func _ready():
	pass
		
func _physics_process(delta):
	pass

func onHit(dmg):
	hpCopmonent.damage(dmg)

func onDeath():
	queue_free()

