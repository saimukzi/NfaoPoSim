extends Node2D

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)

func _ready():
	anthem_system_node.reg_flag(self)

func update_flag(height):
	$FlagPath/FlagControl.unit_offset = height
