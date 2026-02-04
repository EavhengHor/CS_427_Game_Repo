extends Control

@onready var start_button = $Cardboard_Background/VBoxContainer/Start_Button
@onready var exit_button = $Cardboard_Background/VBoxContainer/Exit_Button

# Audio Nodes
@onready var start_sound = $Start
@onready var exit_sound = $Exit
@onready var background_music = $Background  # This matches the node in your screenshot

func _ready():
	# 1. Start playing background music immediately when the game loads
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
	print("Start button pressed!")
	
	# 1. STOP the background music immediately
	background_music.stop()
	
	# 2. Play the start sound
	start_sound.play()
	
	# 3. Wait for start sound to finish
	await start_sound.finished
	
	# 4. Change scene
	get_tree().change_scene_to_file("res://Example World/Level/Level_1/level_1_main.tscn")

func _on_exit_button_pressed():
	print("Exit button pressed!")
	
	# 1. STOP the background music immediately
	background_music.stop()
	
	# 2. Play the exit sound
	exit_sound.play()
	
	# 3. Wait for exit sound to finish
	await exit_sound.finished
	
	# 4. Quit
	get_tree().quit()
