class_name Main
extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and !event.is_echo():
		get_tree().quit()
