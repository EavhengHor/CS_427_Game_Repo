extends Control

@onready var start_button = $Panel/Button

func _ready():
	# Check if Start button exists
	if start_button == null:
		print("ERROR: Start_Button not found!")
	else:
		print("Start button found, connecting signal...")
		start_button.pressed.connect(_on_start_button_pressed)
	
func _on_start_button_pressed():
	print("Start button pressed! Changing scene to Level 1...")

	get_tree().change_scene_to_file("res://Example World/Level/Level_1/level_1_main.tscn")
