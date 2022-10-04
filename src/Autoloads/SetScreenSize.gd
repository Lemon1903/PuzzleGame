extends Node


var map_size_matrix := Vector2(15, 12)
var map_size_px := map_size_matrix * 32


func _ready() -> void:
	OS.window_size = 2 * map_size_px
