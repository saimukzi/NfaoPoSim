extends Node2D

var splash_ready = false

func _ready():
	state_machine.set_next_state(SplashState.new())

class MyStateMachine extends StateMachine:
	var me
	func _init(me).(): self.me = me
	func default_state(): return MyState.new()

class MyState extends StateMachine.State:
	var me
	func init(): self.me = get_state_machine().me
#	func _on_SplashScene_finish(): pass
#	func _on_TitleScene_start_game(): pass

class SplashState extends MyState:
	var my_scene
	func start():
		my_scene = load("res://SplashScene/SplashScene.tscn").instance()
		my_scene.connect('ready',self,'on_ready')
		my_scene.connect('finish',self,'on_finish')
		me.add_child(my_scene)
	func on_ready():
		my_scene.start()
	func on_finish():
		set_next_state(TitleState.new())
	func end():
		my_scene.queue_free()

class TitleState extends MyState:
	var my_scene
	func start():
		my_scene = load("res://TitleScene/TitleScene.tscn").instance()
		my_scene.connect('start_game',self,'on_start_game')
		me.add_child(my_scene)
	func on_start_game():
		print('ZDFTKXFKCY')
	func end():
		my_scene.queue_free()

onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state()
