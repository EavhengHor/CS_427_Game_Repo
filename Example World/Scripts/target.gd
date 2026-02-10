extends StaticBody3D

@export var Health: int = 10
@export var kill_range: float = 1.5 # The distance at which the player dies

var player = null

func _ready():
	# Finds the player node - ensure your player is in the "player" group!
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if not player or not is_instance_valid(player):
		return

	# Calculate distance between this target and the player
	var dist = global_position.distance_to(player.global_position)
	
	# If the player touches this static object
	if dist < kill_range:
		# Check if player has the die function
		if player.has_method("die"):
			player.die()

# Hit Logic so you can still destroy the target
func Hit_Successful(damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= damage
	print("Static Target Hit! Health: ", Health)
	if Health <= 0:
		die()

func die():
	print("Target Destroyed!")
	queue_free()
