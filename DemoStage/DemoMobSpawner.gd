extends Node2D

const SPAWN_PER_SEC = 1

export(NodePath) var map
onready var map_node = get_node(map)

export(NodePath) var anthem_system
onready var anthem_system_node = get_node(anthem_system)
onready var anthem_system_node_abs_path = anthem_system_node.get_path()

export(NodePath) var game_node_path

onready var mob_scene = preload("res://DemoStage/DemoMob.tscn")
onready var rand = $"/root/Runtime".rand

func _physics_process(delta):
	if (not anthem_system_node.is_flag_busy()) and (rand.randf() < delta / SPAWN_PER_SEC):
		spawn_mod()

func spawn_mod():
	$"Path2D/PathFollow2D".unit_offset = rand.randf()
	var mob_instance = mob_scene.instance() as Node2D
	mob_instance.anthem_system = anthem_system_node_abs_path
	mob_instance.game_node_path = game_node_path
	map_node.add_child(mob_instance)
	mob_instance.global_position = $"Path2D/PathFollow2D".global_position
