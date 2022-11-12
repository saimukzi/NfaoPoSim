extends Node

signal anthem_start()
signal anthem_end()
signal player_guilty(player_node)

export(NodePath) var anthem_system

func _on_AnthemSystem_anthem_end():
	emit_signal("anthem_end")

func _on_GameBase_player_guilty(player_node):
	pass # Replace with function body.
