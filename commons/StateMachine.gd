class_name StateMachine

var state = default_state()
func set_state(new_state):
	if state != null:
		state.end()
		state = null
	if new_state == null:
		state = default_state()
	else:
		state = new_state.new()
	state.state_machine = self
	state.init()
	state.start()

func default_state():
	return State.new()

class State:
	var state_machine
	func set_state(state):
		self.state_machine.set_state(state)
	func init():
		pass
	func start():
		pass
	func end():
		pass
