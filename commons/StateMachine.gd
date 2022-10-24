class_name StateMachine

var state = default_state()
var next_state
func set_next_state(new_state):
	self.next_state = new_state

func default_state():
	return State.new()

func tick():
	if next_state != null:
		if state != null:
			state.end()
			state = null
		state = next_state
		next_state = null
		state.state_machine = self
		state.init()
		state.start()

class State:
	var state_machine
	func set_next_state(state):
		self.state_machine.set_next_state(state)
	func init():
		pass
	func start():
		pass
	func end():
		pass
