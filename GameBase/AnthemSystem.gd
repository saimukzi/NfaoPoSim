extends Node

export(bool) var auto_play = true
export(float) var flag_up_sec = 1.0
export(float) var flag_down_sec = 1.0
export(float) var idle_sec_min = 3.0
export(float) var idle_sec_max = 6.0

onready var timer = $Timer
onready var audio_player = $AudioStreamPlayer
onready var state_machine = StateMachine.new(self)

signal anthem_end()

func _ready():
	print("AnthemSystem._ready")
	if auto_play:
		state_machine.set_state(Idle)
	else:
		state_machine.set_state(Stop)

func _on_Timer_timeout():
	state_machine._on_Timer_timeout()

func _on_AudioStreamPlayer_finished():
	state_machine._on_AudioStreamPlayer_finished()

var playing setget ,playing_get
func playing_get():
	return state_machine.is_playing()

class State:
	var state_machine
	var anthem_system
	func set_state(state):
		self.state_machine.set_state(state)
	func is_playing():
		return false
	func _start():
		pass
	func _on_Timer_timeout():
		pass
	func _on_AudioStreamPlayer_finished():
		pass
	func _end():
		pass

class Stop extends State:
	pass

class Idle extends State:
	func _start():
		print("Idle._start")
		anthem_system.timer.start(rand_range(anthem_system.idle_sec_min,anthem_system.idle_sec_max))
	func _on_Timer_timeout():
		if anthem_system.auto_play:
			set_state(LeftFlagUp)
		else:
			set_state(Stop)

class LeftFlagUp extends State:
	func _start():
		anthem_system.timer.start(anthem_system.flag_up_sec)
	func _on_Timer_timeout():
		set_state(LeftFlagTop)

class LeftFlagTop extends State:
	func _start():
		anthem_system.audio_player.play()
	func _on_AudioStreamPlayer_finished():
		set_state(LeftFlagDown)
	func is_playing():
		return true

class LeftFlagDown extends State:
	func _start():
		anthem_system.timer.start(anthem_system.flag_down_sec)
	func _on_Timer_timeout():
		set_state(Idle)

class StateMachine:
	var anthem_system
	var state = null
	func _init(_anthem_system):
		self.anthem_system = _anthem_system
	func set_state(new_state):
		if state != null:
			state._end()
			state = null
		if new_state != null:
			state = new_state.new()
			state.state_machine = self
			state.anthem_system = anthem_system
			state._start()
	func is_playing():
		if state == null: return false
		return state.is_playing()
	func _on_Timer_timeout():
		if state == null: return
		state._on_Timer_timeout()
	func _on_AudioStreamPlayer_finished():
		if state == null: return
		state._on_AudioStreamPlayer_finished()
