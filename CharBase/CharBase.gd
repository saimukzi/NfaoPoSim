extends Node2D

func set_base_color(color):
	$Base.modulate = color

func set_eye_color(color):
	$EyeL.modulate = color
	$EyeR.modulate = color
