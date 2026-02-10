extends CharacterBody3D

@export var speed = 4.0
@export var Health = 10

# Randomize this range for every burger
var detection_range = 0.0 
var is_chasing = false

# Separation variable
var separation_distance = 2.5 

# How close they need to be to kill you (1.5 meters is touching distance)
var attack_range = 1.5

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	# Randomize detection range (Longer range now)
	detection_range = randf_range(30.0, 80.0)
	print("Burger spawned with eyes range: ", detection_range)

func _physics_process(_delta):
	if not player:
		return

	# Calculate distance to player
	var dist = global_position.distance_to(player.global_position)
	
	# --- NEW: KILL THE PLAYER ---
	if dist < attack_range:
		# Check if player has the die function we just made
		if player.has_method("die"):
			player.die()

	# Logic: Only chase if close enough
	if dist < detection_range:
		if is_chasing == false:
			is_chasing = true
			
		look_at(player.global_position, Vector3.UP)
		rotation.x = 0
		rotation.z = 0
		
		# Move towards player + Separation force
		var target_velocity = -transform.basis.z * speed
		var push_vector = get_separation_force()
		velocity = target_velocity + push_vector
		
		move_and_slide()
	else:
		velocity = Vector3.ZERO
		is_chasing = false

# Separation Logic
func get_separation_force() -> Vector3:
	var push = Vector3.ZERO
	var neighbors = get_tree().get_nodes_in_group("Target")
	
	for neighbor in neighbors:
		if neighbor == self:
			continue 
			
		var dist_to_neighbor = global_position.distance_to(neighbor.global_position)
		
		if dist_to_neighbor < separation_distance:
			var direction_away = (global_position - neighbor.global_position).normalized()
			push += direction_away * (separation_distance - dist_to_neighbor)
			
	return push * 2.0

# Hit Logic
func Hit_Successful(damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= damage
	print("Burger Hit! Health: ", Health)
	if Health <= 0:
		die()

func die():
	print("Burger Destroyed!")
	queue_free()
