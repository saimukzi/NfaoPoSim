extends Node2D

var move_speed = 200

func _physics_process(delta):
	# process move
	var move_vector = Vector2.ZERO
	
	if Input.is_action_pressed("game_up"):
		move_vector.y -= 1
	if Input.is_action_pressed("game_down"):
		move_vector.y += 1
	if Input.is_action_pressed("game_left"):
		move_vector.x -= 1
	if Input.is_action_pressed("game_right"):
		move_vector.x += 1

	move_vector = move_vector.limit_length()
	move_vector *= move_speed * delta
	
	position += move_vector

	if move_vector.length() > 0:
		rotation = move_vector.angle()

	# process move on anthem
	if move_vector.length() > 0:
		if is_anthem_playing():
			print("Anthem playing!!!")

	# process eat
	if Input.is_action_pressed("game_eat"):
		$PlayerEatMobExecuteCollisionLayer.monitorable = true
	else:
		$PlayerEatMobExecuteCollisionLayer.monitorable = false

func is_anthem_playing():
	var anthem_system = get_anthem_system()
	if anthem_system == null:
		return false
	return anthem_system.get("playing")

export(NodePath) var game_base
var game_base_node_cache:Node
var game_base_node_cache_done = false
func get_game_base() -> Node:
	if not game_base_node_cache_done:
		if game_base != null:
			game_base_node_cache = get_node(game_base)
		game_base_node_cache_done = true
	return game_base_node_cache

var anthem_system_node_cache:Node
var anthem_system_node_cache_done = false
func get_anthem_system() -> Node:
	if not anthem_system_node_cache_done:
		var game_base = get_game_base()
		if game_base != null:
			var anthem_system_path:NodePath = game_base.get("anthem_system")
			if anthem_system_path != null:
				anthem_system_node_cache = game_base.get_node(anthem_system_path)
		anthem_system_node_cache_done = true
	return anthem_system_node_cache
