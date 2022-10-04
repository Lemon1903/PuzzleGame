extends Actor


onready var Grid := get_parent()
onready var timer := $Timer
onready var tween := $Tween
onready var sprite := $enemy
onready var line_of_sight := $LineOfSight
onready var anim_player := $AnimationPlayer

# state
enum states {PATROL, CHASE, RETURN, ATTACK}
var state = states.PATROL
var is_attacking := false
var in_attack_range := false

# get the patrol path for the enemy
export var patrol_path :NodePath
var path_points :PoolVector2Array
var path_index := 0
var forward := -1

var type = Cells.TYPES.ENEMY
var player_pos := Vector2.ZERO


func _on_area_entered(area: Area2D) -> void:
	anim_player.stop(true)
	if not $detected.is_visible():
		anim_player.play("show")
	timer.start()
	in_attack_range = true
	state = states.ATTACK
	player_pos = Grid.world_to_map(area.position)


func _on_area_exited(area: Area2D) -> void:
	anim_player.stop(true)
	if $detected.is_visible():
		anim_player.play("hide")
	is_attacking = false
	in_attack_range = false
	state = states.PATROL
	player_pos = Vector2.ZERO


func _on_animation_finished(anim_name: String) -> void:
	# emits a signal for player died
	if anim_name == "attack" and in_attack_range:
		PlayerData.player_died()


func _on_level_completed() -> void:
	set_process(false)


func _ready() -> void:
	if patrol_path:
		current_speed = running_speed
		update_look_at(sprite, start_facing, line_of_sight)
		Grid.get_parent().connect("level_completed", self, "_on_level_completed")
		var points = get_node(patrol_path).curve.get_baked_points()
		for point in points:
			path_points.append(Grid.world_to_map(point))


func _process(delta: float) -> void:
	if not Engine.editor_hint:
		if not state in [states.CHASE, states.ATTACK]:
			check_for_player()
		
		# stop for a sec when changing into some actions
		if timer.get_time_left() == 0:
			handle_action()


func check_for_player() -> void:
	line_of_sight.force_raycast_update()
	var collider = line_of_sight.get_collider()
	if collider is Player:
		timer.start()
		state = states.CHASE
		anim_player.play("show")
		player_pos = Grid.world_to_map(collider.position)


func handle_action() -> void:
	if is_attacking:
		return
	
	var direction := Vector2.ZERO
	var map_pos = Grid.world_to_map(position)
	match state:
		states.PATROL:
			anim_player.play("RESET")
			var target = path_points[path_index]
			if map_pos.distance_to(target) < 1:
#				# for circle paths to be right
				if path_points[0] == target:
					path_index = 0
				# when reaching the endpoints of the patrol path
				if path_index in [0, path_points.size() - 1]:
					timer.start()
					forward *= -1
				path_index += forward
			else:
				direction = map_pos.direction_to(target)
			
		states.CHASE:
			if map_pos.distance_to(player_pos) < 1:
				timer.start()
				state = states.RETURN
				anim_player.play("hide")
			else:
				direction = map_pos.direction_to(player_pos)
		
		states.RETURN:
			if map_pos.distance_to(path_points[path_index]) < 1:
				state = states.PATROL
			else:
				# TODO: needs to fix path when going back
				direction = map_pos.direction_to(path_points[path_index])
		
		states.ATTACK:
			var direction_to_player = map_pos.direction_to(player_pos)
			if direction_to_player.x != 0:  # prevents diagonal direction
				direction_to_player = Vector2.RIGHT if direction_to_player.x > 0 else Vector2.LEFT
			
			update_look_at(sprite, direction_to_player, line_of_sight)
			is_attacking = true
			anim_player.play("attack")
	
	var target_pos = Grid.get_target_pos(self, direction)
	if target_pos:
		update_look_at(sprite, direction, line_of_sight)
		move_to(position, target_pos, tween)
