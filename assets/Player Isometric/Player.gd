extends Node2D


onready var Grid := get_parent()
onready var tween := $Tween
onready var sprite := $player
onready var anim_player := $AnimationPlayer
onready var sprites_facing = {
	Vector2.UP: preload("res://Assets/Player Isometric/player_back 32x32.png"),
	Vector2.DOWN: preload("res://Assets/Player Isometric/player_front 32x32.png"),
	Vector2.LEFT: preload("res://Assets/Player Isometric/player_left 32x32.png"),
	Vector2.RIGHT: preload("res://Assets/Player Isometric/player_right 32x32.png")
}


func _process(_delta: float) -> void:
	var input = get_input()
	if not input:
		return
	
	var target_pos = Grid.get_target_pos(self, input)
	sprite.texture = sprites_facing[input]
	move_to(target_pos)


func get_input() -> Vector2:
	var input_vec = Vector2.ZERO
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		input_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	elif Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
		input_vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vec


func move_to(target_position:Vector2) -> void:
	set_process(false)
	anim_player.play("walk")
	
	tween.interpolate_property(
		self, "position", 
		position, target_position,
		anim_player.current_animation_length,
		Tween.TRANS_QUART, Tween.EASE_IN)
	tween.start()
	
	yield(anim_player, "animation_finished")
	set_process(true)
