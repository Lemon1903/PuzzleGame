extends Actor
class_name Crate


onready var Grid := get_parent()
onready var tween := $Tween
onready var sprite := $crate
var type = Cells.TYPES.CRATE


func _on_TargetDetector_area_entered(_area: Area2D) -> void:
	sprite.modulate = Color("#b26969")


func _on_TargetDetector_area_exited(_area: Area2D) -> void:
	sprite.modulate = Color("#ffffff")


func move(direction:Vector2):
	var target_pos = Grid.get_target_pos(self, direction)
	if target_pos:
		current_speed = pushing_speed
		move_to(position, target_pos, tween)
	return target_pos
