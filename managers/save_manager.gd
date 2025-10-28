class_name SaveManager
extends Node2D

const LATEST_SHOT_PATH: String = "savedata/latest_shot.png"
const FRAME_PATH_TEMPLATE: String = "savedata/frame%02d.png"


func load_latest_shot() -> Texture2D:
	return _load_path(LATEST_SHOT_PATH)


func save_latest_shot(texture: Texture2D) -> void:
	_save_path(LATEST_SHOT_PATH, texture)


func load_frame(frame: int) -> Texture2D:
	return _load_path(FRAME_PATH_TEMPLATE % frame)


func save_frame(frame: int, texture: Texture2D) -> void:
	_save_path(FRAME_PATH_TEMPLATE % frame, texture)


func _load_path(path: String) -> Texture2D:
	if !FileAccess.file_exists(path):
		return null
	var image: Image = Image.load_from_file(path)
	return ImageTexture.create_from_image(image)


func _save_path(path: String, texture: Texture2D) -> void:
	var image: Image = texture.get_image()
	image.save_png(path)
