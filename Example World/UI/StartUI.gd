extends Control

@onready var main_menu = $MainMenu
@onready var how_to_play_menu = $HowToPlayMenu

# --- NEW: Potato Background Nodes ---
@onready var potato_bg_1 = $PotatoBorder_Background
@onready var potato_bg_2 = $PotatoBorder_Background2
@onready var potato_bg_3 = $PotatoBorder_Background3

# Button paths
@onready var start_button = $MainMenu/VBoxContainer/Start_Button
@onready var exit_button = $MainMenu/VBoxContainer/Exit_Button2 

# Audio Nodes
@onready var start_sound = $Start
@onready var exit_sound = $Exit
@onready var background_music = $Background

var is_transitioning = false

func _ready():
	if background_music:
		background_music.play()
	
	if main_menu: main_menu.show()
	if how_to_play_menu: how_to_play_menu.hide()

# --- HOW TO PLAY SWAP ---

func _on_how_to_play_pressed():
	if is_transitioning: return
	
	if main_menu and how_to_play_menu:
		main_menu.hide()
		how_to_play_menu.show()
		
		# Hide the potatoes when the orange screen opens!
		if potato_bg_1: potato_bg_1.hide()
		if potato_bg_2: potato_bg_2.hide()
		if potato_bg_3: potato_bg_3.hide()

func _on_back_button_pressed():
	if is_transitioning: return
	
	if main_menu and how_to_play_menu:
		how_to_play_menu.hide()
		main_menu.show()
		
		# Bring the potatoes back when returning to the main menu!
		if potato_bg_1: potato_bg_1.show()
		if potato_bg_2: potato_bg_2.show()
		if potato_bg_3: potato_bg_3.show()

# --- ORIGINAL START/EXIT LOGIC ---

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
