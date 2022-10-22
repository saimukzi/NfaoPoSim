extends Node2D

export(NodePath) var map
#var mob_base_scene : PackedScene
var random_move_mob_scene : PackedScene

func _ready():
#	mob_base_scene = preload("res://Mobs/MobBase/MobBase.tscn")
	random_move_mob_scene = preload("res://Mobs/RandomMoveMob/RandomMoveMob.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("debug_spawn"):
#		var mob_instance = mob_base_scene.instance() as Node2D
		var mob_instance = random_move_mob_scene.instance() as Node2D
		mob_instance.position = position
		get_node(map).add_child(mob_instance)
