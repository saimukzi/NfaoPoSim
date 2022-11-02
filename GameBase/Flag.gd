extends Node2D

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

func _ready():
	anthem_system_node.reg_flag(self)

func update_flag(height):
	$FlagPath/FlagControl.unit_offset = height

func play():
	state_machine.set_next_state(FlagPrepare.new())

func flag_time_remain():
	return state().flag_time_remain()

func _on_PrepareTimer_timeout():
	state()._on_PrepareTimer_timeout()

func _on_AudioStreamPlayer2D_finished():
	state()._on_AudioStreamPlayer2D_finished()

func _process(delta):
	state()._process(delta)

class MyState extends StateMachine.State:
	var me
	func init(): self.me = get_state_machine().me
	func _process(delta): pass
	func _on_PrepareTimer_timeout(): pass
	func _on_AudioStreamPlayer2D_finished(): pass
	func flag_time_remain(): return 0

class Idle extends MyState:
	pass

class FlagPrepare extends MyState:
	func start():
		me.get_node('PrepareTimer').start(me.anthem_system_node.flag_prepare_sec)
	func _on_PrepareTimer_timeout():
		set_next_state(FlagUp.new())

class FlagUp extends MyState:
	var player
	func start():
		self.player = me.get_node('AudioStreamPlayer2D')
		self.player.play()
		me.anthem_system_node.emit_signal("flag_start", self)
	func _process(_delta):
		var ret = self.player.get_playback_position()
		ret /= player.stream.get_length()
		ret = clamp(ret,0,1)
		me.update_flag(ret)
	func flag_time_remain():
		return player.stream.get_length()-player.get_playback_position()
	func _on_AudioStreamPlayer2D_finished():
		set_next_state(Idle.new())
	func end():
		self.player.seek(0)
		me.update_flag(1)
		me.anthem_system_node.emit_signal("flag_done", self)

class MyStateMachine extends StateMachine:
	var me
	func _init(me): self.me = me
	func default_state(): return MyState.new()

onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state()
