class_name StateMachine

extends Reference

var state
var next_state

func _init():
	state = default_state()
	state.state_machine_wref = weakref(self)
	state.init()

func set_next_state(new_state):
	var old_next_state_exist = (self.next_state!=null)
	self.next_state = new_state
	if not old_next_state_exist:
		self.call_deferred("exec_change_state")

func default_state():
	return State.new()

func exec_change_state():
	if next_state == null: return
	if state != null:
		state.end()
		state = null
	state = next_state
	next_state = null
	state.state_machine_wref = weakref(self)
	state.init()
	state.start()

class State extends Reference:
	var state_machine_wref
	func get_state_machine():
		return state_machine_wref.get_ref()
	func set_next_state(state):
		get_state_machine().set_next_state(state)
	func init():
		pass
	func start():
		pass
	func end():
		pass
