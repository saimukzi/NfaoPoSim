extends Node2D

func _on_EatDetection_area_entered(area):
	print("_on_EatDetection_area_entered %s"%area.name)
