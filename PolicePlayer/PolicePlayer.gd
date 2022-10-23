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
	if anthem_system_node == null:
		return false
	return anthem_system_node.get("playing")

export(NodePath) var game_base
onready var game_base_node = get_node(game_base)
onready var anthem_system_node = game_base_node.get_node(game_base_node.get("anthem_system"))
