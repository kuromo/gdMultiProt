extends Node

var users 

func _ready():
	var file = "res://data/usrData.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		print("usrData json was loaded")
		users = json_as_dict


func saveUsrAcc():
	print("save data to file")
	var filePath = "res://data/usrData.json"
	var file = FileAccess.open(filePath,FileAccess.WRITE)
	file.store_line(JSON.stringify(users, "\t"))
