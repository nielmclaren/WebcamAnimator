class_name TimelineFrameControl
extends Control

@export var frame_texture: TextureRect
@export var select_button: Button
@export var current_indicator: ColorRect

var _webcam_animator: WebcamAnimator
var _frame_index: int = -1
var _is_current: bool = false


func setup(webcam_animator: WebcamAnimator, index: int) -> TimelineFrameControl:
	_webcam_animator = webcam_animator
	_frame_index = index
	return self


func get_frame() -> Texture2D:
	return frame_texture.texture


func is_current() -> bool:
	return _is_current


func is_selected() -> bool:
	return select_button.button_pressed


func load() -> void:
	frame_texture.texture = _webcam_animator.save_manager.load_frame(_frame_index)


func save() -> void:
	_webcam_animator.save_manager.save_frame(_frame_index, frame_texture.texture)


func set_button_group(group: ButtonGroup) -> void:
	select_button.button_group = group


func set_is_current(value: bool) -> void:
	_is_current = value
	if _is_current:
		current_indicator.color = Color.WHITE
	else:
		current_indicator.color = Color.BLACK


func write_frame(texture: Texture2D) -> void:
	frame_texture.texture = Utils.duplicate_texture(texture)
	save()
