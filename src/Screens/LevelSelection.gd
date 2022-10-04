extends Control


func _ready() -> void:
	for level in LevelsManager.game_data["levels_unlocked"]:
		var row1_button = get_node("Selection Background/Selections/Row1/" + level)
		var row2_button = get_node("Selection Background/Selections/Row2/" + level)
		
		if row1_button:
			row1_button.disabled = false
		elif row2_button:
			row2_button.disabled = false
