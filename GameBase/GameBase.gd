extends Node

signal anthem_start()
signal anthem_end()

export(NodePath) var anthem_system

func _on_AnthemSystem_anthem_end():
	emit_signal("anthem_end")
