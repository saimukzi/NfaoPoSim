extends Label

export(NodePath) var player_node_path
onready var player_node = get_node(player_node_path)

func update_txt():
	self.text = str(player_node.score)

func _ready():
	update_txt()

func _on_GameBase_player_score_change(player_node):
	if player_node != self.player_node: return
	update_txt()
