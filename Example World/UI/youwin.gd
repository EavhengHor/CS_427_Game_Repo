extends Control

# --- DRAG YOUR BUTTONS HERE IN THE INSPECTOR ---
@export var play_again_button: TextureButton 
@export var exit_button: TextureButton

var is_transitioning = false

func _ready():
	# Make sure the mouse is visible so the player can click buttons
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if play_again_button:
		if not play_again_button.pressed.is_connected(_on_play_again_pressed):
			play_again_button.pressed.connect(_on_play_again_pressed)
	
	if exit_button:
		if not exit_button.pressed.is_connected(_on_exit_pressed):
			exit_button.pressed.connect(_on_exit_pressed)

func _on_play_again_pressed():
	if is_transitioning: return
	is_transitioning = true
	
	print("Restarting Game: Loading Level 1...")
	# Change this path to your actual Level 1 scene path
	get_tree().change_scene_to_file("res://Example World/Level/level_1_main.tscn")
	
func _on_exit_pressed():
	if is_transitioning: return
	is_transitioning = true
	get_tree().quit()
