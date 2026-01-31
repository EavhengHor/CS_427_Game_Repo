extends CharacterBody3D

@export var speed := 6.0
@export var intro_sound: AudioStream
@export var loop_sound: AudioStream

var start_pos := Vector3(0.482, 0.268, 2.638)
var target_pos := Vector3(0.482, 0.268, 191.0)

var moving := false
var can_detect := false
var can_restart := false

@onready var label := $Label3D
@onready var boss_music := get_node("/root/World/BossMusic")

func _ready():
	print("Bot ready")

	# Reset state
	global_position = start_pos
	moving = false
	can_detect = false
	can_restart = false

	# Hide potato + label
	hide()
	label.visible = false

	# ▶ Play intro sound once
	boss_music.stop()
	boss_music.stream = intro_sound
	boss_music.play()
	boss_music.finished.connect(_on_intro_finished)

	# ⏳ Wait 6 seconds (hidden)
	await get_tree().create_timer(6.0).timeout

	# 👀 Show potato
	show()
	label.visible = true
	label.text = "Catch me if u can"

	# ⏳ Wait 3 seconds before moving
	await get_tree().create_timer(3.0).timeout

	# 🏃 Enable movement & detection
	can_detect = true
	moving = true


func _on_intro_finished():
	print("Intro finished → looping music")

	boss_music.stream = loop_sound
	boss_music.play()
	boss_music.finished.connect(_on_loop_finished)


func _on_loop_finished():
	boss_music.play()


func _physics_process(_delta):
	if not moving:
		return

	var dir = (target_pos - global_position).normalized()
	velocity = dir * speed
	move_and_slide()


func _on_area_3d_body_entered(body):
	if not can_detect:
		return

	if not body is CharacterBody3D:
		return

	if body.name != "Player_Character":
		return

	# 🏆 WIN STATE
	label.text = "You win!\nPress P to play again"
	moving = false
	can_restart = true
	boss_music.stop()


func _input(event):
	if can_restart and event.is_action_pressed("play_again"):
		get_tree().reload_current_scene()
