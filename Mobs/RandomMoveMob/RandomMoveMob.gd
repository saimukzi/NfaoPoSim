extends "res://Mobs/MobBase/MobBase.gd"

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

var speed = 50
var timeout = 0.0

func _ready():
	anthem_system_node.connect('flag_start',self,'_on_flag_start')
	anthem_system_node.connect('flag_done',self,'_on_flag_done')

func _physics_process(delta):
	while delta > 0:
		if timeout <= 0:
			rotation = rand_range(0,2*PI)
			timeout += rand_range(0,2)
		var process_time = min(delta, timeout)
		if process_time > 0:
			var move_v2 = Vector2.RIGHT.rotated(rotation)
			move_v2 *= speed
			move_v2 *= process_time
			position += move_v2
			delta -= process_time
			timeout -= process_time
