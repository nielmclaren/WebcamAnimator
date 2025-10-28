class_name TimelineControl
extends Control

@export var frame_controls: Array[TimelineFrameControl]
@export var select_frame_button_group: ButtonGroup

signal frame_changed

var _webcam_animator: WebcamAnimator

var _frame_index: int = 0
var _anim_timer: Timer


func setup(webcam_animator: WebcamAnimator) -> TimelineControl:
	_webcam_animator = webcam_animator

	for index: int in frame_controls.size():
		var frame: TimelineFrameControl = frame_controls[index]
		frame.setup(_webcam_animator, index)

	return self


func get_frame_texture() -> Texture2D:
	return frame_controls[_frame_index].get_frame()


func load() -> void:
	for frame: TimelineFrameControl in frame_controls:
		frame.load()


func write_selected_frames(texture: Texture2D) -> void:
	for frame: TimelineFrameControl in frame_controls:
		if frame.is_selected():
			frame.write_frame(texture)


func _ready() -> void:
	for frame: TimelineFrameControl in frame_controls:
		frame.set_button_group(select_frame_button_group)

	_init_anim_timer()


func _init_anim_timer() -> void:
	_anim_timer = Timer.new()
	_anim_timer.timeout.connect(_anim_timer_timeout)
	_anim_timer.wait_time = 0.5

	add_child(_anim_timer)
	_anim_timer.start()


func _anim_timer_timeout() -> void:
	frame_controls[_frame_index].set_is_current(false)

	_frame_index += 1
	if _frame_index >= frame_controls.size():
		_frame_index = 0

	frame_controls[_frame_index].set_is_current(true)

	frame_changed.emit()
