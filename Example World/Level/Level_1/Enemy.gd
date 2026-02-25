extends CharacterBody3D

@export var speed := 6.0

var start_pos := Vector3(0.482, 0.268, 20.638)
var target_pos := Vector3(0.482, 0.268, 191.0)

var moving := false
var can_detect := false
var can_restart := false
var can_go_to_boss := false

@onready var label := $Label3D

func _ready():
	print("Bot ready")
	
	# Reset state
	global_position = start_pos
	moving = false
	can_detect = false
	can_restart = false
	can_go_to_boss = false
	
	# Hide potato + label
	hide()
	label.visible = false
	
	# ⏳ Wait exactly 3 seconds
	await get_tree().create_timer(3.0).timeout
	
	# 👀 Show potato and enable movement instantly
	show()
	label.visible = true
	label.text = "Catch me if u can"
	
	can_detect = true
	moving = true

# ---------------------------------------------------------
# Called when the player dies
# ---------------------------------------------------------
func player_died():
	print("Player Died!")
	
	moving = false
	can_detect = false
	can_restart = true # Allows restarting Level 1
	label.text = "Game Over\nPress P to restart"

# ---------------------------------------------------------

func _physics_process(_delta):
	if not moving:
		return
		
	var dir = (target_pos - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

func _on_area_3d_body_entered(body):
	if not can_detect:
		return
		
	if body.name == "Player_Character":
		# 🏆 CATCH STATE
		label.text = "Caught!\nPress P to enter Final Boss"
		moving = false
		can_restart = false # We aren't restarting Level 1
		can_go_to_boss = true

func _input(event):
	# If caught, press P to go to the Boss Level
	if can_go_to_boss and event.is_action_pressed("play_again"):
		print("Entering Final Boss Level...")
		get_tree().change_scene_to_file("res://Example World/Level/final_boss_level/final_boss_level.tscn")
	
	# Keep your existing restart logic for when you lose
	if can_restart and event.is_action_pressed("play_again"):
		get_tree().reload_current_scene()
