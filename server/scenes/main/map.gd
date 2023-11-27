extends Node
var enemyIdCounter = 0
var maxEnemies = 3
var enemyTypes = ["herbert"]
var enemySpawnPoints = [Vector2(360, 230), Vector2(390, 150), Vector2(200, 70), Vector2(120, 165), Vector2(200, 250)]
var openSpawns = [0,1,2,3,4]
var occupiedSpawns = {}
var enemyList = {}


func _ready():
	var timer = Timer.new()
	timer.wait_time = 3
	timer.autostart = true
	timer.connect("timeout", spawnEnemy)
	add_child(timer)


func spawnEnemy():
	if enemyList.size() >= maxEnemies:
		pass
	else:
		randomize()
		var type = enemyTypes[randi() % enemyTypes.size()]
		var rngSpawn = randi() % openSpawns.size()
		var location = enemySpawnPoints[openSpawns[rngSpawn]]
		occupiedSpawns[enemyIdCounter] = openSpawns[rngSpawn]
		openSpawns.remove_at(rngSpawn)
		enemyList[enemyIdCounter] = {"type": type, "location": location, "health": 2000, "maxHealth": 2000, "state": "idle", "timeout": 1}
		enemyIdCounter += 1
	for enemy in enemyList.keys():
		if enemyList[enemy].state == "dead":
			if enemyList[enemy].timeout == 0:
				enemyList.erase(enemy)
			else:
				enemyList[enemy].timeout = enemyList[enemy].timeout - 1


func NPCHit(enemyId, dmg):
	if enemyList[enemyId]["health"] <= 0:
		pass
	else:
		enemyList[enemyId]["health"] = enemyList[enemyId]["health"] - dmg
		if enemyList[enemyId]["health"] <= 0:
			enemyList[enemyId]["state"] = "dead"
			openSpawns.append(occupiedSpawns[enemyId])
			occupiedSpawns.erase(enemyId)
