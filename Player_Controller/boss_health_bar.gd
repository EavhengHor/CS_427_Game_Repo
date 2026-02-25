extends ProgressBar

var boss = null
var player = null

func _ready():
	# Start hidden so it doesn't flash on screen in Level 1
	hide()
	show_percentage = false
	
	# Hide the text label at the start too
	var hp_text = get_node_or_null("%DialogLabel2")
	if hp_text:
		hp_text.hide()

func _process(_delta):
	# 1. Find the player to check if we are in a Boss Level
	if player == null:
		player = get_tree().get_first_node_in_group("player") # Ensure your Player is in the "player" group
	
	# 2. If it's not a boss level, stay hidden and stop here
	if player and not player.is_boss_level:
		return
	
	# 3. If it IS a boss level, find the boss
	if boss == null:
		var targets = get_tree().get_nodes_in_group("Target")
		for t in targets:
			if "current_health" in t:
				boss = t
				max_value = float(boss.max_health)
				
				# Show the UI now that the boss is found
				show()
				var hp_text = get_node_or_null("%DialogLabel2")
				if hp_text:
					hp_text.show()
				break
	
	# 4. Sync the health every frame
	if boss != null:
		value = float(boss.current_health)
		
		# Update the text label
		var hp_text = get_node_or_null("%DialogLabel2")
