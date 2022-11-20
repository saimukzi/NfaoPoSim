extends Node

signal finish()

func _ready():
	state_machine.set_next_state(InitState.new())

func _input(event):
	state()._input(event)

func is_next_event(event):
	if event is InputEventKey and event.pressed:
		return true
#	if event is InputEventMouseButton and event.pressed:
#		return true
	return false

func start():
	state_machine.set_next_state(DeveloperState.new())

class MyState extends StateMachine.State:
	var me
	func init(): self.me = get_state_machine().me
	func _input(event): pass

class InitState extends MyState:
	func start():
		me.get_node('Developer').hide()
		me.get_node('Disclaimer').hide()

class DeveloperState extends MyState:
	func start():
		me.get_node('Developer').show()
		me.get_node('Disclaimer').hide()
	func _input(event):
		if me.is_next_event(event):
			set_next_state(DisclaimerState.new())

class DisclaimerState extends MyState:
	func start():
		me.get_node('Developer').hide()
		me.get_node('Disclaimer').show()
	func _input(event):
		if me.is_next_event(event):
			set_next_state(EndState.new())

class EndState extends MyState:
	func start():
		me.get_node('Developer').hide()
		me.get_node('Disclaimer').hide()
		me.emit_signal('finish')

class MyStateMachine extends StateMachine:
	var me
	func _init(me).(): self.me = me
	func default_state(): return MyState.new()

onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state()

