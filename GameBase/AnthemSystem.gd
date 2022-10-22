extends Node

var playing setget ,playing_get

signal anthem_end()

func _ready():
	start_timer()

func playing_get():
	return $AudioStreamPlayer.playing

func _on_NextStartTimer_timeout():
	$AudioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	start_timer()
	emit_signal("anthem_end")

func start_timer():
	$NextStartTimer.start(rand_range(5,10))
