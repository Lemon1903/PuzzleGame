extends Node


var game_data :Dictionary = {"levels_unlocked" : []}
var default_data :Dictionary = {"levels_unlocked" : []}
var save_path := "user://save.dat"


func save_data(file_data) -> void:
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "020622")
	if error == OK:
		file.store_var(game_data)
		if not game_data["levels_unlocked"].has(file_data):
			game_data["levels_unlocked"].append(file_data)
	file.close()


func load_data() -> void:
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "020622")
		if error == OK:
			game_data = file.get_var()
		file.close()
	else:
		game_data = default_data


func reset_data() -> void:
	var dir = Directory.new()
	if dir.file_exists(save_path):
		dir.remove(save_path)
	game_data = default_data.duplicate(true)
