extends Node

export(bool) var auto_play = true
export(float) var flag_up_sec = 1.0
export(float) var flag_down_sec = 1.0
export(float) var idle_sec_min = 3.0
export(float) var idle_sec_max = 6.0

onready var timer = $Timer
onready var audio_player = $AudioStreamPlayer
onready var state_machine = MyStateMachine.new(self)

signal anthem_end()

func _ready():
	if auto_play:
		state_machine.set_state(Idle)
	else:
		state_machine.set_state(Stop)

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
	func _on_Timer_timeout():
		pass
	func _on_AudioStreamPlayer_finished():
		pass

class Stop extends MyState:
	pass

class Idle extends MyState:
	func start():
		anthem_system.timer.start(rand_range(anthem_system.idle_sec_min,anthem_system.idle_sec_max))
	func _on_Timer_timeout():
		if anthem_system.auto_play:
			set_state(LeftFlagUp)
		else:
			set_state(Stop)

class LeftFlagUp extends MyState:
	func start():
		anthem_system.timer.start(anthem_system.flag_up_sec)
	func _on_Timer_timeout():
		set_state(LeftFlagTop)

class LeftFlagTop extends MyState:
	func start():
		anthem_system.audio_player.play()
	func _on_AudioStreamPlayer_finished():
		set_state(LeftFlagDown)
	func is_playing():
		return true

class LeftFlagDown extends MyState:
	func start():
		anthem_system.timer.start(anthem_system.flag_down_sec)
	func _on_Timer_timeout():
		set_state(Idle)

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
