extends Node

export(bool) var auto_play = true
export(float) var flag_down_sec = 0.5
export(float) var idle_sec_min = 3.0
export(float) var idle_sec_max = 6.0

var flag_node_ary = []

onready var rand = $"/root/Runtime".rand
onready var timer = $Timer
onready var audio_player = $AudioStreamPlayer
onready var state_machine = MyStateMachine.new(self)
onready var audio_length = audio_player.stream.get_length()

signal anthem_end()

func _ready():
	if auto_play:
		state_machine.set_next_state(Idle.new())
	else:
		state_machine.set_next_state(Stop.new())

func reg_flag(flag_node):
	flag_node_ary.append(flag_node)

func _physics_process(_delta):
	state_machine.tick()

func _process(delta):
	state()._process(delta)

func _on_Timer_timeout():
	state()._on_Timer_timeout()

func _on_AudioStreamPlayer_finished():
	state()._on_AudioStreamPlayer_finished()

class MyState extends StateMachine.State:
	var anthem_system
	func init():
		anthem_system = state_machine.anthem_system
	func is_playing():
		return false
	func _process(_delta):
		pass
	func _on_Timer_timeout():
		pass
	func _on_AudioStreamPlayer_finished():
		pass

class Stop extends MyState:
	pass

class Idle extends MyState:
	func start():
		anthem_system.timer.start(anthem_system.rand.randf_range(anthem_system.idle_sec_min,anthem_system.idle_sec_max))
	func _on_Timer_timeout():
		if anthem_system.auto_play:
			set_next_state(FlagDown.new())
		else:
			set_next_state(Stop.new())

class FlagDown extends MyState:
	var flag_node
	func start():
		var flag_node_ary = anthem_system.flag_node_ary
		flag_node = flag_node_ary[anthem_system.rand.randi_range(0,flag_node_ary.size()-1)]
		anthem_system.timer.start(anthem_system.flag_down_sec)
	func _process(_delta):
		var ret = anthem_system.timer.time_left/anthem_system.timer.wait_time
		ret = clamp(ret,0,1)
		flag_node.update_flag(ret)
	func _on_Timer_timeout():
		set_next_state(FlagUp.new(flag_node))
	func end():
		flag_node.update_flag(0)

class FlagUp extends MyState:
	var flag_node
	func _init(flag_node).():
		self.flag_node = flag_node
	func start():
		anthem_system.audio_player.play()
	func _process(_delta):
		var ret = anthem_system.audio_player.get_playback_position()
		ret /= anthem_system.audio_length
		ret = clamp(ret,0,1)
		flag_node.update_flag(ret)
	func _on_AudioStreamPlayer_finished():
		set_next_state(Idle.new())
	func is_playing():
		return true
	func end():
		flag_node.update_flag(1)

class MyStateMachine extends StateMachine:
	var anthem_system
	func _init(_anthem_system):
		self.anthem_system = _anthem_system
	func default_state():
		return MyState.new()

func state():
	return state_machine.state

func is_playing():
	return state().is_playing()
