extends Node # <--- ADD THIS LINE TO FIX THE 'get_tree()' ERROR

func _on_body_entered(body):
	# Only kill the PLAYER. Ignore the boss or minions hitting the wall.
	if body.is_in_group("player"):
		print("Player touched the wall! Triggering death.")
		
		# 1. Stop the Boss patrol without killing it
		var boss = get_tree().get_first_node_in_group("Target")
		if boss and boss.has_method("player_lost"):
			boss.player_lost()
			
		# 2. Kill the player
		if body.has_method("die"):
			body.die()
