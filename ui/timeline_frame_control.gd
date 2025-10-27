class_name TimelineFrameControl
extends Control

@export var frame_texture: TextureRect
@export var select_button: Button
@export var current_indicator: ColorRect

var _is_current: bool = false


func get_frame() -> Texture2D:
	return frame_texture.texture


func set_button_group(group: ButtonGroup) -> void:
	select_button.button_group = group


func is_current() -> bool:
	return _is_current


func set_is_current(value: bool) -> void:
	_is_current = value
	if _is_current:
		current_indicator.color = Color.WHITE
	else:
		current_indicator.color = Color.BLACK


func is_selected() -> bool:
	return select_button.button_pressed


func write_frame(texture: Texture2D) -> void:
	frame_texture.texture = Utils.duplicate_texture(texture)
