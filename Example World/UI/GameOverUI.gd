extends Control

# --- DRAG YOUR BUTTONS HERE IN THE INSPECTOR ---
@export var play_again_button: TextureButton 
@export var exit_button: TextureButton

var is_transitioning = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# --- CONNECT PLAY AGAIN BUTTON ---
	if play_again_button:
		# Safety Check: Only connect if it isn't connected yet!
		if not play_again_button.pressed.is_connected(_on_play_again_pressed):
			play_again_button.pressed.connect(_on_play_again_pressed)
	else:
		print("❌ ERROR: You forgot to drag the PlayAgain_Button into the Inspector script slot!")

	# --- CONNECT EXIT BUTTON ---
	if exit_button:
		# Safety Check: Only connect if it isn't connected yet!
		if not exit_button.pressed.is_connected(_on_exit_pressed):
			exit_button.pressed.connect(_on_exit_pressed)
	else:
		print("❌ ERROR: You forgot to drag the Exit_Button into the Inspector script slot!")

func _on_play_again_pressed():
	print("🖱️ Play Again CLICKED!")
	if is_transitioning:
		return
	
	is_transitioning = true
	
	# CHANGE SCENE - Make sure this path is exactly right for your game
	get_tree().change_scene_to_file("res://Example World/Level/Level_1/level_1_main.tscn")

func _on_exit_pressed():
	print("🖱️ Exit CLICKED!")
	if is_transitioning:
		return
		
	is_transitioning = true
	get_tree().quit()
