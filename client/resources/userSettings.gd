class_name UserSettings extends Resource

# audio settings
@export_range(0, 100, 1) var musicVolume: float = 100
@export_range(0, 100, 1) var sfxVolume: float = 100

# input settings
@export var actionEvents: Dictionary = {}

# video settings
@export var windowMode: int = 0

func save() -> void:
	ResourceSaver.save(self, "user://userSettings.tres")


static func loadOrCreate() -> UserSettings:
	var res: UserSettings = load("user://userSettings.tres")
	if !res:
		res = UserSettings.new()
	
	return res
