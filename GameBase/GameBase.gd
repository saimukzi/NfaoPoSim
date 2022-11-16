extends Node

signal anthem_start()
signal anthem_end()
signal player_guilty(player_node)
signal player_life_change(player_node)
signal player_score_change(player_node)
signal player_eat_mob(player_node,mob_node)

export(NodePath) var anthem_system

func _on_AnthemSystem_anthem_end():
	emit_signal("anthem_end")
