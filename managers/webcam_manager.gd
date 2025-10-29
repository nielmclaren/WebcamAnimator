class_name WebcamManager
extends Node2D

var _target_camera_name: String = "Insta360 Link 2C: Insta360 Link"
var _camera: CameraFeed
var _texture: CameraTexture


func get_texture() -> CameraTexture:
	return _texture


func _init() -> void:
	_texture = CameraTexture.new()


func _ready() -> void:
	CameraServer.monitoring_feeds = true
	CameraServer.camera_feeds_updated.connect(_camera_feeds_updated)


func _camera_feeds_updated() -> void:
	if _camera:
		return

	print("WebcamManager Cameras:")
	for feed in CameraServer.feeds():
		if feed.get_name() == _target_camera_name:
			_camera = feed

	if _camera == null:
		push_warning("WebcamManager No matching camera camera_name=", _target_camera_name)
		return

	print(
		"WebcamManager Using camera id=",
		_camera.get_id(),
		" ",
		_camera,
		" (",
		_camera.get_name(),
		")"
	)

	#print("WebcamManager Number of formats: ", _camera.formats.size())
	for index: int in _camera.formats.size():
		#print(index, "\t", _camera.formats[index])
		pass

	# TODO: Don't hardcode the format index?
	var format_index: int = 8

	var format: Dictionary = _camera.formats[format_index]
	print("WebcamManager Using format: ", format)
	var format_result: bool = _camera.set_format(format_index, {})
	if !format_result:
		push_error("WebcamManager Failed to set camera format.")
		return

	_camera.feed_is_active = true

	_texture.camera_feed_id = _camera.get_id()
	_texture.which_feed = CameraServer.FEED_Y_IMAGE
