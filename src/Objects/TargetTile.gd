extends Area2D


onready var anim_player := $AnimationPlayer
var current_animation = "idle"


func _on_area_entered(area: Area2D) -> void:
	current_animation = "hide"
	PlayerData.target_tiles -= 1


func _on_area_exited(area: Area2D) -> void:
	current_animation = "show"
	PlayerData.target_tiles += 1


func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"hide":
			current_animation = ""
		"show":
			current_animation = "idle"


func _process(delta: float) -> void:
	if current_animation != "":
		anim_player.play(current_animation)
