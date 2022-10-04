extends StaticBody2D
class_name Actor


export var start_facing :Vector2
export var running_speed := 4.0
export var pushing_speed := 2.0
var current_speed := running_speed


func move_to(start_pos:Vector2, target_pos:Vector2, tween:Tween) -> void:
	set_process(false)
	
	tween.interpolate_property(
		self, "position",
		start_pos, target_pos, 1/current_speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	yield(tween, "tween_completed")
	set_process(true)


func update_look_at(sprite:Sprite, direction:Vector2, raycast:RayCast2D = null) -> void:
	sprite.rotation = direction.angle()
	if raycast:
		raycast.rotation = sprite.rotation
