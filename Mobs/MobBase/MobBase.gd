extends Node2D

export(NodePath) var game_node_path
onready var game_node = get_node_or_null(game_node_path)

func _ready():
	$EatDetectionDisplay.hide()
	if game_node != null:
		game_node.connect('player_eat_mob',self,'_on_player_eat_mob')

func _on_PlayerEatMobDisplayCollisionMask_area_entered(area):
	# print("_on_PlayerEatDisplayMask_area_entered %s"%area.name)
	$EatDetectionDisplay.show()

func _on_PlayerEatMobDisplayCollisionMask_area_exited(area):
	$EatDetectionDisplay.hide()

func _on_PlayerEatMobExecuteCollisionMask_area_entered(area):
	print("_on_PlayerEatMobExecuteCollisionMask_area_entered %s"%area.name)
	for _0 in 1:
		var is_guilty = is_guilty()
		if not is_guilty(): break
		var player_node_path = area.get_meta('player_node_path')
		if player_node_path == null: break
		var player_node = get_node_or_null(player_node_path)
		if player_node == null: break
		if game_node == null: break
		game_node.emit_signal('player_eat_mob',player_node,self)

func _on_player_eat_mob(player_node,mob_node):
	if mob_node != self: return
	queue_free()

func is_guilty():
	return false
