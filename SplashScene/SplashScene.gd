extends Node

signal finish()

func _ready():
	pass

func next_input_pressed():
  if Input.is_action_pressed("ui_ok"):
	return true

class MyState extends StateMachine.State:
	var me
	func init(): self.me = get_state_machine().me

class InitState extends MyState:
	func start():
		me.$Developer.hide()
		me.$Disclaimer.hide()

class DeveloperState extends MyState:
	func start():
		me.$Developer.show()
		me.$Disclaimer.hide()
	func _process(delta):
		if me.next_input_pressed():
			set_next_state(DisclaimerState.new())

class DisclaimerState extends MyState:
	func start():
		me.$Developer.hide()
		me.$Disclaimer.show()
	func _process(delta):
		if me.next_input_pressed():
			set_next_state(EndState.new())

class EndState extends MyState:
	func start():
		me.$Developer.hide()
		me.$Disclaimer.hide()
		me.emit_signal('finish')

class MyStateMachine extends StateMachine:
	var me
	func _init(me).(): self.me = me
	func default_state(): return MyState.new()
