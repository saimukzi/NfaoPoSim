extends Node

signal flag_done(flag_node)

export(bool) var auto_play = true
export(float) var flag_prepare_sec = 0.5
export(float) var flag_down_sec = 0.5
export(float) var idle_sec_min = 3.0
export(float) var idle_sec_max = 6.0

var flag_node_ary = []

onready var rand = $"/root/Runtime".rand
onready var timer = $Timer

signal anthem_end()

func _ready():
	self.connect("flag_done",self,"_on_flag_done")
	if auto_play:
		$Timer.start(rand.randf_range(idle_sec_min,idle_sec_max))

func reg_flag(flag_node):
	flag_node_ary.append(flag_node)

func _on_Timer_timeout():
	var flag_node = flag_node_ary[rand.randi_range(0,flag_node_ary.size()-1)]
	flag_node.play()

func _on_flag_done(flag_node):
	if auto_play:
		$Timer.start(rand.randf_range(idle_sec_min,idle_sec_max))
