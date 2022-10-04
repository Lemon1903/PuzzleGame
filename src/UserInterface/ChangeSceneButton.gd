tool
extends Button


export(String, FILE) var next_scene_path := ""


func _on_button_up() -> void:
	if name == "NewGameButton":
		LevelsManager.reset_data()
	elif name == "ContinueButton":
		LevelsManager.load_data()
	
	get_tree().paused = false
	get_tree().change_scene(next_scene_path)


func _get_configuration_warning() -> String:
	return "Next scene path must not be empty." if not next_scene_path else ""
