extends PathFollow2D

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

export(Global.Flag) var flag = Global.Flag.LEFT

func _process(_delta):
	# print(anthem_system_node.get_flag_height(AnthemSystem.Flag.LEFT))
	unit_offset = anthem_system_node.get_flag_height(Global.Flag.LEFT)
