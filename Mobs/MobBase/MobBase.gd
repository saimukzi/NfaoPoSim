extends Node2D

func _ready():
	$EatDetectionDisplay.hide()

func _on_EatDetection_area_entered(area):
	# print("_on_EatDetection_area_entered %s"%area.name)
	$EatDetectionDisplay.show()

func _on_EatDetection_area_exited(area):
	$EatDetectionDisplay.hide()
