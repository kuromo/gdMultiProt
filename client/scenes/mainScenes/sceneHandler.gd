extends Node

var map = preload("res://scenes/mainScenes/map.tscn")

func _ready():
	var mapInstance = map.instantiate()
	add_child(mapInstance)
	pass
