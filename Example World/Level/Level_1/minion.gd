extends CharacterBody3D

@export var speed = 4.0
@export var Health = 10
@export var attack_range = 2.0 

var player = null

func _ready():
	add_to_group("Target")
	# BACKUP: Try to find the player again in case they spawned late
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	# If player still isn't found, try finding them again one last time
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return

	# Look at player
	var target_pos = player.global_position
	target_pos.y = global_position.y 
	look_at(target_pos, Vector3.UP)
	
	# Move
	velocity = -transform.basis.z * speed
	move_and_slide()
	
	# Kill
	if global_position.distance_to(player.global_position) < attack_range:
		if player.has_method("die"):
			player.die()

func Hit_Successful(damage, _dir = Vector3.ZERO, _pos = Vector3.ZERO):
	Health -= damage
	if Health <= 0:
		queue_free()
