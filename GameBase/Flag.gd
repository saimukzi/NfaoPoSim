extends Node2D

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

func _ready():
	anthem_system_node.reg_flag(self)

func update_flag(height):
	$FlagPath/FlagControl.unit_offset = height

class MyState extends StateMachine.State:
	var flag_node
	func init():
		flag_node = state_machine.flag_node

class Idle extends MyState:
	pass

class MyStateMachine extends StateMachine:
	var flag_node
	func _init(flag_node):
		self.flag_node = flag_node
	func default_state():
		return MyState.new()

onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state
