extends Control

@onready var main_menu = $MainMenu
@onready var how_to_play_menu = $HowToPlayMenu
@onready var easter_egg_menu = $EasterEgg

# Background/Extra Nodes
@onready var potato_bg_1 = $PotatoBorder_Background
@onready var potato_bg_2 = $PotatoBorder_Background2
@onready var potato_bg_3 = $PotatoBorder_Background3
@onready var easter_egg_button = $EasterEggButton

# Audio
@onready var start_sound = $Start
@onready var exit_sound = $Exit
@onready var background_music = $Background

var is_transitioning = false

func _ready():
	if background_music:
		background_music.play()
	
	main_menu.show()
	how_to_play_menu.hide()
	easter_egg_menu.hide()
	_toggle_extras(true) # Make sure potatoes are visible at start

# --- HELPER: Shows/Hides the potatoes and the floating egg button ---
func _toggle_extras(is_visible: bool):
	if potato_bg_1: potato_bg_1.visible = is_visible
	if potato_bg_2: potato_bg_2.visible = is_visible
	if potato_bg_3: potato_bg_3.visible = is_visible
	if easter_egg_button: easter_egg_button.visible = is_visible

# --- MENU NAVIGATION ---

func _on_how_to_play_pressed():
	if is_transitioning: return
	main_menu.hide()
	how_to_play_menu.show()
	_toggle_extras(false) # Hide the fluff

func _on_back_button_pressed():
	if is_transitioning: return
	how_to_play_menu.hide()
	main_menu.show()
	_toggle_extras(true) # Bring fluff back

func _on_easter_egg_button_pressed():
	if is_transitioning: return
	main_menu.hide()
	easter_egg_menu.show()
	_toggle_extras(false) # Hide the fluff

func _on_easter_egg_back_pressed():
	if is_transitioning: return
	easter_egg_menu.hide()
	main_menu.show()
	_toggle_extras(true) # Bring fluff back

# --- GAME ACTIONS ---

func _on_start_button_pressed():
	if is_transitioning: return
	is_transitioning = true
	background_music.stop()
	start_sound.play()
	await start_sound.finished
	get_tree().change_scene_to_file("res://Example World/Level/Level_1/level_1_main.tscn")

func _on_exit_button_pressed():
	if is_transitioning: return
	is_transitioning = true
	background_music.stop()
	exit_sound.play()
	await exit_sound.finished
	get_tree().quit()
