extends Node2D

var me_ready = false
var splash_ready = false

func _ready():
	state_machine.set_next_state(InitState.new())
	me_ready = true
	splash_tick()

func _on_SplashScene_finish():
	state()._on_SplashScene_finish()

func _on_SplashScene_ready():
	splash_ready = true
	splash_tick()

var splash_tick_done = false
func splash_tick():
	if not me_ready: return
	if not splash_ready: return
	if splash_tick_done: return
	splash_tick_done = true
	state_machine.set_next_state(SplashState.new())

class MyStateMachine extends StateMachine:
	var me
	func _init(me).(): self.me = me
	func default_state(): return MyState.new()

class MyState extends StateMachine.State:
	var me
	func init(): self.me = get_state_machine().me
	func _on_SplashScene_finish(): pass

class InitState extends MyState:
	pass

class SplashState extends MyState:
	func start():
		me.get_node('SplashScene').start()

onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state()
