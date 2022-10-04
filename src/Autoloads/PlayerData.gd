extends Node


signal player_died

var target_tiles :int
var number_of_steps :int


func player_died() -> void:
	emit_signal("player_died")
