extends Node2D

func _ready():
	$EatDetectionDisplay.hide()

func _on_PlayerEatMobDisplayCollisionMask_area_entered(area):
	# print("_on_PlayerEatDisplayMask_area_entered %s"%area.name)
	$EatDetectionDisplay.show()

func _on_PlayerEatMobDisplayCollisionMask_area_exited(area):
	$EatDetectionDisplay.hide()

func _on_PlayerEatMobExecuteCollisionMask_area_entered(area):
	print("_on_PlayerEatMobExecuteCollisionMask_area_entered %s"%area.name)
	queue_free()
