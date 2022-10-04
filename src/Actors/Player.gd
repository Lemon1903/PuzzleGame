extends Actor
class_name Player


onready var Grid := get_parent()
onready var tween := $Tween
onready var sprite := $player
onready var died_texture := preload("res://assets/player_died.png")

var type = Cells.TYPES.PLAYER
var is_dead := false


func _ready() -> void:
	update_look_at(sprite, start_facing)
	PlayerData.connect("player_died", self, "on_player_died")
	Grid.get_parent().connect("level_completed", self, "on_level_completed")


func _process(_delta: float) -> void:
	if not is_dead:
		var direction = get_input()
		current_speed = running_speed
		if not direction:
			return
		
		update_look_at(sprite, direction)
		var target_pos = Grid.get_target_pos(self, direction)
		if target_pos:
			move_to(position, target_pos, tween)
			PlayerData.number_of_steps += 1


func get_input() -> Vector2:
	var input_vec = Vector2.ZERO
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		input_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	elif Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
		input_vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vec


func on_player_died() -> void:
	is_dead = true
	sprite.texture = died_texture


func on_level_completed() -> void:
	set_process(false)
