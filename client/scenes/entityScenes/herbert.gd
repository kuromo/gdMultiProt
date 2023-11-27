extends CharacterBody2D

var maxHealth
var currentHealth
var state
var type

func _ready():
	var percentHP = int((float(currentHealth) / maxHealth) * 100)
	$HPBar.update()
	if state == "idle":
		pass # add idle animation here
	elif state == "dead":
		queue_free() # add dead spryite here if needed
		
func _physics_process(delta):
	pass


func moveEnemy(newPos):
	position = newPos


func updateHealth(health):
	if health != currentHealth:
		currentHealth = health
		$HPBar.update()
		if currentHealth <= 0:
			onDeath()

func onHit(dmg):
	server.NPCHit(int(str(name)), dmg)
#	hpCopmonent.damage(dmg)

func onDeath():
	#can add death animation here
	queue_free()

