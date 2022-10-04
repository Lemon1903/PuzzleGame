extends Node2D


signal level_completed

export(int) var target_tiles
export(PackedScene) var next_level

onready var scene_tree := get_tree()


func _ready() -> void:
	LevelsManager.save_data(name)
	PlayerData.number_of_steps = 0
	PlayerData.target_tiles = target_tiles


func _process(delta: float) -> void:
	if PlayerData.target_tiles == 0:
		yield($Grid/Player/Tween, "tween_completed")
		if name == "Level 11":
			set_process(false)
			$Tutorial/Tween.interpolate_property(
				$Tutorial/Tutorial1, "percent_visible", 
				0, 1, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tutorial/Tween.start()
		else:
			emit_signal("level_completed")
			yield(scene_tree.create_timer(1.0), "timeout")
			scene_tree.change_scene_to(next_level)
