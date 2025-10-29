class_name CropControl
extends Control

signal crop_changed


var _left_rect: ColorRect
var _right_rect: ColorRect
var _top_rect: ColorRect
var _bottom_rect: ColorRect

# Track the last good crop we can revert to.
var _prev_crop: Rect2

# The current crop, including temporary crop while mouse dragging.
var _crop: Rect2

# The starting point of the crop while mouse dragging.
var _crop_start: Vector2
var _is_dragging: bool = false


func get_crop() -> Rect2:
	return _crop


func set_crop(value: Rect2) -> void:
	_crop = value
	_crop_changed()


func load(crop_data: Dictionary) -> void:
	var crop_x: float = crop_data.x
	var crop_y: float = crop_data.y
	var crop_width: float = crop_data.width
	var crop_height: float = crop_data.height

	var pos: Vector2 = Vector2(crop_x, crop_y)
	var siz: Vector2 = Vector2(crop_width, crop_height)
	_crop = Rect2(pos, siz)
	_crop_changed()


func save() -> Dictionary:
	return {
		"x": _crop.position.x,
		"y": _crop.position.y,
		"width": _crop.size.x,
		"height": _crop.size.y
	}


func _ready() -> void:
	resized.connect(_crop_changed)

	_left_rect = _create_rect()
	_right_rect = _create_rect()
	_top_rect = _create_rect()
	_bottom_rect = _create_rect()

	_crop = Rect2(0, 0, size.x, size.y)
	_crop_changed()


func _create_rect() -> ColorRect:
	var result: ColorRect = ColorRect.new()
	result.color = Color.BLACK
	result.color.a = 0.2
	add_child(result)
	return result


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click_event: InputEventMouseButton = event
		if click_event.button_index == MOUSE_BUTTON_LEFT:
			if click_event.pressed:
				if get_global_rect().has_point(click_event.global_position):
					_crop_start = click_event.global_position - get_global_rect().position
					_is_dragging = true

			else:
				_is_dragging = false
				if get_global_rect().has_point(click_event.global_position):
					_set_crop(_crop_start, click_event.global_position - get_global_rect().position)
					crop_changed.emit()
					_prev_crop = _crop

				else:
					_revert_crop()

	elif _is_dragging and event is InputEventMouseMotion:
		var motion_event: InputEventMouseMotion = event
		if get_global_rect().has_point(motion_event.global_position):
			_set_crop(_crop_start, motion_event.global_position - get_global_rect().position)


func _set_crop(start: Vector2, end: Vector2) -> void:
	var top_left: Vector2 = Vector2(minf(start.x, end.x), minf(start.y, end.y))
	var bottom_right: Vector2 = Vector2(maxf(start.x, end.x), maxf(start.y, end.y))
	_crop = Rect2(top_left, bottom_right - top_left)
	_crop_changed()


func _revert_crop() -> void:
	_crop = _prev_crop
	_crop_changed()


func _crop_changed() -> void:
	_left_rect.position.x = 0
	_left_rect.position.y = 0
	_left_rect.size.x = _crop.position.x
	_left_rect.size.y = size.y

	_right_rect.position.x = _crop.position.x + _crop.size.x
	_right_rect.position.y = 0
	_right_rect.size.x = size.x - _crop.position.x - _crop.size.x
	_right_rect.size.y = size.y

	_top_rect.position.x = _crop.position.x
	_top_rect.position.y = 0
	_top_rect.size.x = _crop.size.x
	_top_rect.size.y = _crop.position.y

	_bottom_rect.position.x = _crop.position.x
	_bottom_rect.position.y = _crop.position.y + _crop.size.y
	_bottom_rect.size.x = _crop.size.x
	_bottom_rect.size.y = size.y - _crop.position.y - _crop.size.y
