extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func propRot(rot):
#	print("Main rota")
#	print(rot)
	for node in get_tree().get_nodes_in_group("billboardRotation"):
		node.rotation += rot
	
