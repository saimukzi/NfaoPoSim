extends Node

var rand = RandomNumberGenerator.new()
func _ready():
	rand.randomize()

const PHI = (1+sqrt(5))/2
