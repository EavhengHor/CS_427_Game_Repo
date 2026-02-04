extends Control

@onready var start_button = $Cardboard_Background/VBoxContainer/Start_Button
@onready var exit_button = $Cardboard_Background/VBoxContainer/Exit_Button

# Audio Nodes
@onready var start_sound = $Start
@onready var exit_sound = $Exit
@onready var background_music = $Background

# 1. Add this variable to track if a button was already clicked
var is_transitioning = false

func _ready():
	# Start playing background music immediately
	if background_music:
		background_music.play()
	else:
		print("ERROR: Background music node not found")

	# Connect signals
	if start_button:
		start_button.pressed.connect(_on_start_button_pressed)
	
	if exit_button:
		exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	# 2. Check if we are already transitioning. If yes, stop here.
	if is_transitioning:
		return
	
	# 3. "Lock" the buttons so further clicks are ignored
	is_transitioning = true
	
	print("Start button pressed!")
	
	# STOP the background music immediately
	background_music.stop()
	
	# Play the start sound
	start_sound.play()
	
	# Wait for start sound to finish
	await start_sound.finished
	
	# Change scene
	get_tree().change_scene_to_file("res://Example World/Level/Level_1/level_1_main.tscn")

func _on_exit_button_pressed():
	# 2. Check if we are already transitioning. If yes, stop here.
	if is_transitioning:
		return
		
	# 3. "Lock" the buttons
	is_transitioning = true
	
	print("Exit button pressed!")
	
	# STOP the background music immediately
	background_music.stop()
	
	# Play the exit sound
	exit_sound.play()
	
	# Wait for exit sound to finish
	await exit_sound.finished
	
	# Quit
	get_tree().quit()
