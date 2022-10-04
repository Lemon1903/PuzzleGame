extends StaticBody2D


func _process(delta: float) -> void:
	var collider = $RayCast2D.get_collider()
	print(collider)
