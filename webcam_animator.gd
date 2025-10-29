class_name WebcamAnimator
extends Node2D

@export var webcam_manager: WebcamManager
@export var save_manager: SaveManager

@export var webcam_texrect: TextureRect
@export var shoot_button: Button
@export var latest_shot_texrect: TextureRect
@export var anim_texrect: TextureRect
@export var crop_control: CropControl
@export var play_button: Button
@export var pause_button: Button
@export var timeline_control: TimelineControl


func _ready() -> void:
	webcam_texrect.texture = webcam_manager.get_texture()

	shoot_button.pressed.connect(_shoot_pressed)

	crop_control.crop_changed.connect(_save)

	timeline_control.setup(self)
	timeline_control.frame_changed.connect(_timeline_control_frame_changed)

	play_button.pressed.connect(_play)
	pause_button.pressed.connect(_pause)

	_load()


func _shoot_pressed() -> void:
	var texture: Texture2D = webcam_manager.get_texture()
	latest_shot_texrect.texture = Utils.duplicate_texture(texture)

	timeline_control.write_selected_frames(texture)

	save_manager.save_latest_shot(texture)


func _timeline_control_frame_changed() -> void:
	anim_texrect.texture = timeline_control.get_frame_texture()


func _load() -> void:
	latest_shot_texrect.texture = save_manager.load_latest_shot()
	anim_texrect.texture = save_manager.load_frame(0)
	timeline_control.load()

	if FileAccess.file_exists("savedata/default.json"):
		var save_file: FileAccess = FileAccess.open("savedata/default.json", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string: String = save_file.get_line()

			# Creates the helper class to interact with JSON.
			var json: JSON = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure.
			var parse_result: int = json.parse(json_string)
			if !parse_result == OK:
				print(
					"JSON Parse Error: ",
					json.get_error_message(),
					" in ",
					json_string,
					" at line ",
					json.get_error_line()
				)
				continue

			# Get the data from the JSON object.
			var node_data: Dictionary = json.data
			if node_data.has("crop"):
				var crop_data: Dictionary = node_data.crop
				crop_control.load(crop_data)


func _save() -> void:
	var save_file: FileAccess = FileAccess.open("savedata/default.json", FileAccess.WRITE)
	if !save_file:
		print("Failed to save. errcode=", FileAccess.get_open_error())
		return

	var save_data: Dictionary = {"crop": crop_control.save()}
	save_file.store_line(JSON.stringify(save_data))


func _play() -> void:
	pause_button.button_pressed = false
	play_button.button_pressed = true
	timeline_control.play()


func _pause() -> void:
	pause_button.button_pressed = true
	play_button.button_pressed = false
	timeline_control.pause()
