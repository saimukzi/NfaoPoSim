extends Node

signal end()

class MyState extends StateMachine.State:
	var me
	func init(): self.me = get_state_machine().me
	func _on_Game_player_life_change(player_node): pass
	func _input(event): pass
func _on_Game_player_life_change(player_node):
	state()._on_Game_player_life_change(player_node)
func _input(event):
	state()._input(event)

class GameState extends MyState:
	func _on_Game_player_life_change(player_node):
		set_next_state(GameOverState.new())

class GameOverState extends MyState:
	func start():
		me.get_node('GameOver').show()
	func _input(event):
		if event is InputEventKey and event.pressed:
			set_next_state(EndState.new())

class EndState extends MyState:
	func start():
		me.emit_signal('end')

class MyStateMachine extends StateMachine:
	var me
	func _init(me).(): self.me = me
	func default_state(): return GameState.new()
onready var state_machine = MyStateMachine.new(self)
func state():
	return state_machine.state()
