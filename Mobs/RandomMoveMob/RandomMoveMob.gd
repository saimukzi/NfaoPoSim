extends "res://Mobs/MobBase/MobBase.gd"

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

onready var rand = $"/root/Runtime".rand

var speed = 50
var guilty_sec = 1
var guilty_chance = 2-Const.PHI

func _ready():
	anthem_system_node.connect('flag_start',self,'_on_flag_start')
	anthem_system_node.connect('flag_done',self,'_on_flag_done')
	state_machine.set_next_state(NormalState.new())

class MyState extends StateMachine.State:
	var me
	func init(): self.me = get_state_machine().me
	func _physics_process(delta): pass
	func _on_flag_start(flag_node): pass
	func _on_flag_done(flag_node): pass

func _physics_process(delta):
	state()._physics_process(delta)
func _on_flag_start(flag_node): state()._on_flag_start(flag_node)
func _on_flag_done(flag_node): state()._on_flag_done(flag_node)

class NormalState extends MyState:
	var rotate_timeout = 0
	func _physics_process(delta):
		while delta > 0:
			if rotate_timeout <= 0:
				me.rotation = rand_range(0,2*PI)
				rotate_timeout += rand_range(1,2)
			var process_time = min(delta, rotate_timeout)
			if process_time > 0:
				var move_v2 = Vector2.RIGHT.rotated(me.rotation)
				move_v2 *= me.speed
				move_v2 *= process_time
				me.position += move_v2
				delta -= process_time
				rotate_timeout -= process_time
	func _on_flag_start(flag_node):
		set_next_state(FlagState.new(flag_node))

class FlagState extends MyState:
	var flag_node
	var rand_time_total
	var non_guilty_chance
	func _init(flag_node):
		self.flag_node = flag_node
	func init():
		.init()
		rand_time_total = flag_node.flag_time_total() - me.guilty_sec
		non_guilty_chance = 1-me.guilty_chance
	func start():
		me.rotation = PI
	func _physics_process(delta):
		var flag_time_remain = flag_node.flag_time_remain()
		if flag_time_remain < me.guilty_sec: return
		var non_guilty_chance_delta = pow(non_guilty_chance, delta/rand_time_total)
		if me.rand.randf() > non_guilty_chance_delta:
			set_next_state(GuiltyState.new(flag_node))
	func _on_flag_done(flag_node):
		set_next_state(NormalState.new())

class GuiltyState extends MyState:
	var flag_node
	func _init(flag_node): self.flag_node = flag_node
	func start():
		run()
	func run():
		me.rotation = 0
		yield(me.get_tree().create_timer(me.guilty_sec), "timeout")
		set_next_state(FlagState.new(flag_node))

class MyStateMachine extends StateMachine:
	var me
	func _init(me).(): self.me = me
	func default_state(): return MyState.new()

onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state()
