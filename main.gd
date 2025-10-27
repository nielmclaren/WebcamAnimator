class_name Main
extends Node2D

@export var sprite: Sprite2D

var _camera_name: String = "Insta360 Link 2C: Insta360 Link"
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
		if feed.get_name() == _camera_name:
			_camera = feed

	if _camera == null:
		push_warning("No matching camera camera_name=", _camera_name)
		return

	print("using camera id=", _camera.get_id(), " ", _camera, " (", _camera.get_name(), ")")

	print("Number of formats: ", _camera.formats.size())
	for index: int in _camera.formats.size():
		print(index, "\t", _camera.formats[index])

	var format_index: int = 8
	var format: Dictionary = _camera.formats[format_index]
	print("Using format: ", format)
	var format_result: bool = _camera.set_format(format_index, {})
	if !format_result:
		push_error("Failed to set camera format.")
		return

	_camera.feed_is_active = true

	var texture: CameraTexture = CameraTexture.new()
	texture.camera_feed_id = _camera.get_id()
	texture.which_feed = CameraServer.FEED_Y_IMAGE
	sprite.texture = texture

	var texture_dimensions: Vector2 = Vector2(format.width, format.height)
	var sprite_dimensions: Vector2 = Vector2(400, 500)
	print(texture_dimensions, " ", sprite_dimensions)

	var scale_x: float = sprite_dimensions.x / texture_dimensions.x
	var scale_y: float = sprite_dimensions.y / texture_dimensions.y
	var s: float = min(scale_x, scale_y)
	sprite.scale = Vector2(s, s)
