class_name CamSprite
extends Sprite2D

#
# Based on camera feed tutorial by ahihi
# https://github.com/ahihi/godot_camerafeed_tutorial/tree/main
#

@export var camera_name: String = ""

var _camera: CameraFeed

# Called when the node enters the scene tree for the first time.
func _ready():
	CameraServer.monitoring_feeds = true
	CameraServer.camera_feeds_updated.connect(_camera_feeds_updated)


func _camera_feeds_updated() -> void:
	if _camera:
		return

	print("cameras:")
	for feed in CameraServer.feeds():
		var feed_name: String = feed.get_name()

		# if camera_name is left empty, use the first available _camera
		if _camera == null and (camera_name == "" or feed_name == camera_name):
			_camera = feed

	if _camera == null:
		print("no matching _camera")
		return

	print("using _camera ", _camera.get_id(), " ", _camera, " (", _camera.get_name(), ")")

	print(_camera.formats.size(), " formats")
	for index: int in _camera.formats.size():
		print(index, " ", _camera.formats[index])

	var format_index: int = 8
	print(_camera.formats[format_index])
	var format_result: bool = _camera.set_format(format_index, {})
	if !format_result:
		push_error("Failed to set _camera format.")
		return

	_camera.feed_is_active = true

	var cam_tex_y: CameraTexture = material.get_shader_parameter("camera_y") as CameraTexture
	var cam_tex_CbCr: CameraTexture = material.get_shader_parameter("camera_CbCr") as CameraTexture

	cam_tex_y.camera_feed_id = _camera.get_id()
	cam_tex_CbCr.camera_feed_id = _camera.get_id()

	material.set_shader_parameter("camera_y", cam_tex_y)
	material.set_shader_parameter("camera_CbCr", cam_tex_CbCr)
