extends StaticBody3D

@export var Health: int = 10

func _ready():
	# We will create a small 'detection zone' automatically so we don't 
	# have to guess the distance in _process.
	setup_death_zone()

func setup_death_zone():
	# This creates an invisible sensor around your solid wall
	var detection_area = Area3D.new()
	add_child(detection_area)
	
	# Copy the collision shape from the wall to the sensor
	for child in get_children():
		if child is CollisionShape3D:
			var sensor_shape = child.duplicate()
			detection_area.add_child(sensor_shape)
			# Make the sensor slightly larger than the wall so it triggers on touch
			sensor_shape.scale *= 1.1 
	
	# Connect the sensor to the death logic
	detection_area.body_entered.connect(_on_player_touched)

func _on_player_touched(body):
	# Check if the body is the player
	if body.is_in_group("player"):
		if body.has_method("die"):
			print("Player touched the wall! Triggering death.")
			body.die()

# Your weapon system calls this when you shoot the wall
func Hit_Successful(damage: int, _direction: Vector3 = Vector3.ZERO, _position: Vector3 = Vector3.ZERO):
	Health -= damage
	print("Wall Hit! Health: ", Health)
	if Health <= 0:
		die()

func die():
	print("Wall Destroyed!")
	queue_free()
