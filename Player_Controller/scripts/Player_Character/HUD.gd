extends CanvasLayer

@onready var current_weapon_label = $debug_hud/HBoxContainer/CurrentWeapon
@onready var current_ammo_label = $debug_hud/HBoxContainer2/CurrentAmmo
@onready var current_weapon_stack = $debug_hud/HBoxContainer3/WeaponStack
@onready var hit_sight = $HitSight
@onready var hit_sight_timer = $HitSight/HitSightTimer
@onready var overLay = $Overlay

# --- Reference to the Intro Dialog Label ---
@onready var dialog_label = $DialogLabel 

# --- NEW: BOSS HUD NODES ---
@onready var boss_health_bar = %BossHealthBar 
@onready var boss_text_label = %DialogLabel2 # Using DialogLabel2 from your screenshot

# --- NEW: CONNECT DIRECTLY TO THE BOSS ---
func _ready():
	# Wait one frame to ensure the level and Boss have completely loaded
	await get_tree().process_frame
	
	# Find the Boss using the "Target" group
	var boss = get_tree().get_first_node_in_group("Target")
	
	if boss and boss.has_signal("health_updated"):
		# Connect the boss's damage signal straight to this UI script!
		boss.health_updated.connect(update_boss_health_ui)
		
		# Set the visual bar and text to full health (1000) at the start
		update_boss_health_ui(boss.max_health)

# --- NEW: UPDATE THE VISUALS ---
func update_boss_health_ui(new_health: int):
	# Update the Text Label
	if boss_text_label:
		if new_health > 0:
			boss_text_label.text = "[center][color=red]EVIL POTATO HP: " + str(new_health) + "[/color][/center]"
		else:
			boss_text_label.text = "[center][color=green]POTATO MASHED![/color][/center]"
	
	# Update the Progress Bar smoothly
	if boss_health_bar:
		var tween = get_tree().create_tween()
		tween.tween_property(boss_health_bar, "value", new_health, 0.2)

# --- The Typewriter Function ---
func play_intro_dialog():
	if dialog_label:
		dialog_label.text = "Are you ready to defeat Evil Potato?"
		dialog_label.visible_characters = 0
		dialog_label.show()
		
		# Type out over 6 seconds, then immediately hide
		var tween = get_tree().create_tween()
		tween.tween_property(dialog_label, "visible_characters", dialog_label.text.length(), 5.0)
		tween.tween_callback(dialog_label.hide)

# --- Existing Weapon Manager Functions ---
func _on_weapons_manager_update_weapon_stack(WeaponStack):
	current_weapon_stack.text = ""
	for i in WeaponStack:
		current_weapon_stack.text += "\n"+i.weapon.weapon_name

func _on_weapons_manager_update_ammo(Ammo):
	current_ammo_label.set_text(str(Ammo[0])+" / "+str(Ammo[1]))

func _on_weapons_manager_weapon_changed(WeaponName):
	current_weapon_label.set_text(WeaponName)

func _on_hit_sight_timer_timeout():
	hit_sight.set_visible(false)

func _on_weapons_manager_add_signal_to_hud(_projectile):
	_projectile.Hit_Successfull.connect(_on_weapons_manager_hit_successfull)

func _on_weapons_manager_hit_successfull():
	hit_sight.set_visible(true)
	hit_sight_timer.start()

func load_over_lay_texture(Active:bool, txtr: Texture2D = null):
	overLay.set_texture(txtr)
	overLay.set_visible(Active)

func _on_weapons_manager_connect_weapon_to_hud(_weapon_resouce: WeaponResource):
	_weapon_resouce.update_overlay.connect(load_over_lay_texture)
