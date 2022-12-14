extends Node2D

var life = 3
var score = 0

var move_speed = 200
const ROTATION_EPSILON = 0.0001

func _ready():
	$PlayerEatMobExecuteCollisionLayer.set_meta('player_node_path',get_path())
	game_base_node.connect('player_guilty',self,'_on_player_guilty')
	game_base_node.connect('player_eat_mob',self,'_on_player_eat_mob')
	game_base_node.connect('player_life_change',self,'_on_player_life_change')

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

	# process flag busy
	if anthem_system_node.is_flag_busy():
		var is_guilty = ((move_vector.length() > 0) or (abs(rotation-PI) > ROTATION_EPSILON))
		# print("flag busy!!! {ts}".format({'ts':OS.get_ticks_msec()}))
		if is_guilty and $GuiltyCooldownTimer.is_stopped():
			$GuiltyCooldownTimer.start()
			game_base_node.emit_signal('player_guilty',self)

	# process eat
	if Input.is_action_pressed("game_eat") and life > 0:
		$PlayerEatMobExecuteCollisionLayer.monitorable = true
	else:
		$PlayerEatMobExecuteCollisionLayer.monitorable = false

	# force player die
	if Input.is_action_just_pressed("debug_force_player_die"):
		$BadAudio.play()
		life = 0
		game_base_node.emit_signal('player_life_change',self)

func _on_player_guilty(player_node):
	if player_node != self: return
	$BadAudio.play()
	life -= 1
	game_base_node.emit_signal('player_life_change',self)

func _on_player_eat_mob(player_node,mob_node):
	if player_node != self: return
	$GoodAudio.play()
	score += 1
	game_base_node.emit_signal('player_score_change',self)

func _on_player_life_change(player_node):
	if player_node != self: return
	if life <= 0:
		hide()

func _on_BadAudio_finished():
	if life <= 0:
		queue_free()

export(NodePath) var game_base
onready var game_base_node = get_node(game_base)
onready var anthem_system_node = game_base_node.get_node(game_base_node.get("anthem_system"))
