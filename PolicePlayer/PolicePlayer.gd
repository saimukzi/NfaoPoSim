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
