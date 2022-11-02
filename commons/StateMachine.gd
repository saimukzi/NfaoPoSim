class_name StateMachine

extends Reference

var _state
var next_state

func set_next_state(new_state):
	var old_next_state_exist = (self.next_state!=null)
	self.next_state = new_state
	if not old_next_state_exist:
		self.call_deferred("exec_change_state")

func state():
	if _state == null:
		_state = default_state()
		_state.state_machine_wref = weakref(self)
		_state.init()
	return _state

func default_state():
	return State.new()

func exec_change_state():
	if next_state == null: return
	if _state != null:
		_state.end()
		_state = null
	_state = next_state
	next_state = null
	_state.state_machine_wref = weakref(self)
	_state.init()
	_state.start()

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
