extends Control

@onready var start_button = $Cardboard_Background/VBoxContainer/Start_Button
@onready var exit_button = $Cardboard_Background/VBoxContainer/Exit_Button

func _ready():
	# Check if Start button exists
	if start_button == null:
		print("ERROR: Start_Button not found!")
	else:
		print("Start button found, connecting signal...")
		start_button.pressed.connect(_on_start_button_pressed)
	
	# Check if Exit button exists
	if exit_button == null:
		print("ERROR: Exit_Button not found!")
	else:
		print("Exit button found, connecting signal...")
		exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	print("Start button pressed! Changing scene to Level 1...")
	# Change to Level 1 scene
	get_tree().change_scene_to_file("res://Example World/Level/Level_1/level_1_main.tscn")

func _on_exit_button_pressed():
	print("Exit button pressed! Quitting game...")
	# Quit the application
	get_tree().quit()
