class_name TimelineFrameControl
extends Control

@export var frame_texrect: TextureRect
@export var select_button: Button
@export var current_indicator: ColorRect

signal selected
signal deselected

var _webcam_animator: WebcamAnimator
var _frame_index: int = -1
var _is_current: bool = false
var _prev_texture: Texture2D


func setup(webcam_animator: WebcamAnimator, index: int) -> TimelineFrameControl:
	_webcam_animator = webcam_animator
	_frame_index = index
	return self


func get_frame() -> Texture2D:
	return frame_texrect.texture


func is_current() -> bool:
	return _is_current


func is_selected() -> bool:
	return select_button.button_pressed


func load() -> void:
	frame_texrect.texture = _webcam_animator.save_manager.load_frame(_frame_index)
	_prev_texture = frame_texrect.texture


func save() -> void:
	_webcam_animator.save_manager.save_frame(_frame_index, frame_texrect.texture)


func set_button_group(group: ButtonGroup) -> void:
	if select_button.button_group:
		select_button.button_group.changed.disconnect(_button_group_pressed)

	select_button.button_group = group

	if select_button.button_group:
		select_button.button_group.pressed.connect(_button_group_pressed)


func set_is_current(value: bool) -> void:
	_is_current = value
	if _is_current:
		current_indicator.color = Color.WHITE
	else:
		current_indicator.color = Color.BLACK


func set_is_selected(value: bool) -> void:
	select_button.button_pressed = value
	_select_changed()


# Display the webcam texture live.
func set_live_texture(texture: Texture2D) -> void:
	_prev_texture = frame_texrect.texture
	frame_texrect.texture = texture


func unset_live_texture() -> void:
	frame_texrect.texture = _prev_texture


func write_frame(texture: Texture2D) -> void:
	frame_texrect.texture = Utils.duplicate_texture(texture)
	_prev_texture = frame_texrect.texture
	save()


func _ready() -> void:
	select_button.pressed.connect(_select_button_pressed)


func _select_button_pressed() -> void:
	_select_changed()
	if select_button.button_pressed:
		selected.emit()
	else:
		deselected.emit()


func _select_changed() -> void:
	if !select_button.button_pressed:
		# Stop live update.
		frame_texrect.texture = _prev_texture


func _button_group_pressed(_button: BaseButton) -> void:
	_select_changed()
