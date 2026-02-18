extends CharacterBody3D

@export_group("Stats")
@export var max_health: int = 1000
@export var speed := 8.0

@export_group("Spawning")
@export var burger_scene: PackedScene # Wall scene removed
@export var spawn_interval: float = 4.0

# Internal Movement Variables
var current_health: int = 200
var moving := false
var can_restart := false
var target_height: float = 2.0 

var waypoints: Array[Vector3] = []
var current_target_index := 0
var start_pos := Vector3.ZERO

@onready var spawn_timer := Timer.new()

func _ready():
	add_to_group("Target")
	current_health = max_health
	
	# Delay to ensure level is ready before capturing center point
	await get_tree().create_timer(0.5).timeout
	
	start_pos = global_position
	start_pos.y = target_height
	global_position.y = target_height
	
	setup_waypoints()
	setup_spawn_timer()
	
	hide() 
	await get_tree().create_timer(2.0).timeout
	show()
	
	moving = true
	spawn_timer.start()
	print("Potato Patrol Active. Height: 2.0. Walls removed.")

func setup_waypoints():
	# Pattern: 20 Left -> Center -> 20 Backward -> Center
	waypoints.append(start_pos + Vector3(-20, 0, 0))
	waypoints.append(start_pos)
	waypoints.append(start_pos + Vector3(0, 0, 20))
	waypoints.append(start_pos)

func setup_spawn_timer():
	if not spawn_timer.is_inside_tree():
		add_child(spawn_timer)
	spawn_timer.wait_time = spawn_interval
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _physics_process(delta):
	if not moving or waypoints.is_empty(): 
		return
	
	var target = waypoints[current_target_index]
	var direction = (target - global_position).normalized()
	
	# Horizontal Movement only
	velocity = direction * speed
	velocity.y = 0 
	move_and_slide()
	
	# Check if reached current waypoint
	if global_position.distance_to(target) < 1.0:
		current_target_index = (current_target_index + 1) % waypoints.size()
	
	# Stability and Height Lock
	global_position.y = target_height
	rotation.x = 0
	rotation.z = 0
	
	# Smoothly rotate toward the target
	if direction.length() > 0.1:
		var target_basis = Basis.looking_at(direction)
		basis = basis.slerp(target_basis, 10 * delta)

func _on_spawn_timer_timeout():
	if not moving: return
	
	# Spawning logic simplified: No more walls, just burgers
	if burger_scene:
		var instance = burger_scene.instantiate()
		get_parent().add_child(instance)
		
		# Spawn at the boss position with an offset
		var spawn_offset = -transform.basis.z * 4.0
		instance.global_position = global_position + spawn_offset
		instance.global_position.y = target_height 
		print("Burger spawned.")

func Hit_Successful(damage: int, _dir = Vector3.ZERO, _pos = Vector3.ZERO):
	if not moving: return
	
	current_health -= int(damage)
	print("POTATO HIT! HP: ", current_health)
	
	if current_health <= 0:
		die()

func player_lost():
	moving = false
	spawn_timer.stop()

func die():
	print("POTATO DEFEATED!")
	moving = false
	spawn_timer.stop()
	hide()
	can_restart = true

func _input(event):
	if can_restart and event.is_action_pressed("play_again"):
		get_tree().reload_current_scene()
