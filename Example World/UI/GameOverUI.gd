extends Control

# --- DRAG YOUR BUTTONS HERE IN THE INSPECTOR ---
@export var play_again_button: TextureButton 
@export var exit_button: TextureButton

var is_transitioning = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# --- CONNECT PLAY AGAIN BUTTON ---
	if play_again_button:
		if not play_again_button.pressed.is_connected(_on_play_again_pressed):
			play_again_button.pressed.connect(_on_play_again_pressed)
	else:
		print("❌ ERROR: PlayAgain_Button is missing! Drag it into the Inspector.")

	# --- CONNECT EXIT BUTTON ---
	if exit_button:
		if not exit_button.pressed.is_connected(_on_exit_pressed):
			exit_button.pressed.connect(_on_exit_pressed)
	else:
		print("❌ ERROR: Exit_Button is missing! Drag it into the Inspector.")

func _on_play_again_pressed():
	print("🖱️ Play Again CLICKED! Loading Level 1...")
	
	if is_transitioning:
		return
	is_transitioning = true
	
	# --- USE THE EXACT PATH YOU PROVIDED ---
	get_tree().change_scene_to_file("res://Example World/Level/Level_1/level_1_main.tscn")

func _on_exit_pressed():
	print("🖱️ Exit CLICKED!")
	
	if is_transitioning:
		return
	is_transitioning = true
	
	get_tree().quit()
