extends Node2D

signal flag_done()

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

func _ready():
	anthem_system_node.reg_flag(self)

func update_flag(height):
	$FlagPath/FlagControl.unit_offset = height

func play():
	state_machine.set_next_state(FlagPrepare.new())

func _on_PrepareTimer_timeout():
	state()._on_PrepareTimer_timeout()

func _on_AudioStreamPlayer2D_finished():
	state()._on_AudioStreamPlayer2D_finished()

func _physics_process(_delta):
	state_machine.tick()

func _process(delta):
	state()._process(delta)

class MyState extends StateMachine.State:
	var flag_node
	func init():
		self.flag_node = state_machine.flag_node
	func _process(delta):
		pass
	func _on_PrepareTimer_timeout():
		pass
	func _on_AudioStreamPlayer2D_finished():
		pass

class Idle extends MyState:
	pass

class FlagPrepare extends MyState:
	func start():
		flag_node.get_node('PrepareTimer').start(flag_node.anthem_system_node.flag_prepare_sec)
	func _on_PrepareTimer_timeout():
		set_next_state(FlagUp.new())

class FlagUp extends MyState:
	var player
	func start():
		self.player = flag_node.get_node('AudioStreamPlayer2D')
		self.player.play()
	func _process(_delta):
		var ret = self.player.get_playback_position()
		ret /= player.stream.get_length()
		ret = clamp(ret,0,1)
		flag_node.update_flag(ret)
	func _on_AudioStreamPlayer2D_finished():
		set_next_state(Idle.new())
	func end():
		self.player.seek(0)
		flag_node.update_flag(1)
		flag_node.emit_signal("flag_done")

class MyStateMachine extends StateMachine:
	var flag_node
	func _init(flag_node):
		self.flag_node = flag_node
	func default_state():
		return MyState.new()

onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state
