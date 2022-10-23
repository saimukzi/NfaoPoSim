extends Node2D

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

export(Global.Flag) var flag = Global.Flag.LEFT

func _process(_delta):
	# print(anthem_system_node.get_flag_height(AnthemSystem.Flag.LEFT))
	$FlagPath/FlagControl.unit_offset = anthem_system_node.get_flag_height(Global.Flag.LEFT)
