extends CharacterBody2D

@onready var aniTree = get_node("playerAniTree")
#@onready var aniTree = $playerAniTree
@onready var aniMode = aniTree.get("parameters/playback")

var proj = preload("res://scenes/entityScenes/projectile.tscn")
var canFire = true
var rof = .2
var aaToggle = false
#@export var projectile : PackedScene

var speed = 60
var acceleration = 1
var friction = 1
var attacking = false

func _unhandled_input(event):
	if event.is_action_pressed("autoAttack"):
		aaToggle = !aaToggle

func _physics_process(delta):
	aniLoop()
	move_and_slide()

func _process(delta):
	skillLoop()
	
func aniLoop():
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	if direction != Vector2.ZERO:
		velocity = direction * speed
		velocity = velocity.rotated(rotation)
		#velocity = velocity.lerp(direction * speed, acceleration)
		aniTree.set("parameters/Walk/blend_position", direction)
		aniTree.set("parameters/Idle/blend_position", direction)
		#if aniMode.get_current_node() != "Attack":
		aniMode.travel("Walk")
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		#if aniMode.get_current_node() != "Attack":
		aniMode.travel("Idle")
		#print("setIdle")
		
	if Input.is_action_pressed("rotateRight"):
#		print(rotation)
		rotation +=.02
		owner.propRot(0.02)
	if Input.is_action_pressed("rotateLeft"):
#		print(rotation)
		rotation -=.02
		owner.propRot(-0.02)
	
func skillLoop():
	if aaToggle:
		_startAtt()
	elif Input.is_action_pressed("attack"):
		_startAtt()


func _startAtt():
	aniTree.set("parameters/Attack/blend_position", position.direction_to(get_global_mouse_position()).normalized())
	aniTree.set("parameters/Idle/blend_position", position.direction_to(get_global_mouse_position()).normalized())
	aniMode.travel("Attack")
	
	#@TODO add delta calc like: https://ask.godotengine.org/115442/increasing-weapon-firerate-beyond-framerate-limit
	if canFire == true:
		var fireAngle = get_angle_to(get_global_mouse_position())
		
		canFire = false
		get_node("projAxis").rotation = fireAngle
		var projInst = proj.instantiate()
		projInst.position = get_node("projAxis/projSpawn").get_global_position()
		projInst.rotation = fireAngle + rotation
		owner.add_child(projInst)
		#projInst.transform = $projSpawn.global_transform
		#yield(get_tree().create_timer(rof), "timeout")
		await get_tree().create_timer(rof).timeout
		canFire = true
