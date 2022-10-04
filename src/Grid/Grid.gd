extends TileMap
class_name Grid


func _ready() -> void:
	for child in get_children():
		var child_position := world_to_map(child.position)
		set_cellv(child_position, child.type)


func get_object(cell_target:Vector2) -> Node2D:
	for child in get_children():
		if world_to_map(child.position) == cell_target:
			return child
	return null


func get_target_pos(actor:Node2D, direction:Vector2) -> Vector2:
	var cell_start := world_to_map(actor.position)
	var cell_target := cell_start + direction
	var target_type := get_cellv(cell_target)
	
	if target_type == Cells.TYPES.FLOOR:
		return update_position(actor.type, cell_start, cell_target)
		
	if target_type == Cells.TYPES.CRATE and actor.type == Cells.TYPES.PLAYER:
		var crate := get_object(cell_target)
		var crate_pos = crate.move(direction)
		if crate_pos:
			actor.current_speed = actor.pushing_speed
			return update_position(actor.type, cell_start, cell_target)

	return Vector2.ZERO


func update_position(target_type:int, cell_start:Vector2, cell_target:Vector2) -> Vector2:
	set_cellv(cell_target, target_type)
	set_cellv(cell_start, Cells.TYPES.FLOOR)
	return map_to_world(cell_target) + cell_size/2
