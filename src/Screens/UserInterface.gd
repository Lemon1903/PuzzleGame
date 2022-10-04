extends Control


onready var scene_tree := get_tree()
onready var steps_label := $StepsCount/CountPanel/Count
onready var crates_left_label := $CratesLeft/CountPanel/Count
onready var pause_button := $PauseButton
onready var pause_overlay := $PauseOverlay
onready var timer_label := $Counter
onready var anim_player := $FadeScreen/AnimationPlayer

var time := 0.0
var is_timer_on := false
var pause := false setget set_pause


func _on_PauseButton_button_up() -> void:
	set_pause(true)


func _on_ResumeButton_button_up() -> void:
	set_pause(false)


func on_player_died() -> void:
	yield(scene_tree.create_timer(1.0), "timeout")
	reload_current_scene()


func _ready() -> void:
	time = 0.0
	is_timer_on = true
	anim_player.play("fade_out")
	PlayerData.connect("player_died", self, "on_player_died")


func _process(delta: float) -> void:
	if is_timer_on:
		time += delta
	update_interface()
	

func update_interface() -> void:
	var secs := fmod(time, 60)
	var mins := fmod(time, 60 * 60) / 60
	var hours := fmod(fmod(time, 3600 * 60) / 3600, 24)
	var time_passed := "%02d:%02d:%02d" % [hours, mins, secs]
	timer_label.text = time_passed
	steps_label.text = str(PlayerData.number_of_steps)
	crates_left_label.text = str(PlayerData.target_tiles)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		set_pause(not pause)
		scene_tree.set_input_as_handled()
	
	if event.is_action_pressed("restart"):
		reload_current_scene()


func reload_current_scene() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	scene_tree.reload_current_scene()


func set_pause(value) -> void:
	is_timer_on = not value
	pause = value
	pause_overlay.visible = value
	pause_button.visible = not value
	scene_tree.paused = value
