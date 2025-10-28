class_name WebcamAnimator
extends Node2D

@export var webcam_manager: WebcamManager
@export var save_manager: SaveManager

@export var webcam_texrect: TextureRect
@export var shoot_button: Button
@export var latest_shot_texrect: TextureRect
@export var anim_texrect: TextureRect
@export var timeline_control: TimelineControl


func _ready() -> void:
	webcam_texrect.texture = webcam_manager.get_texture()

	shoot_button.pressed.connect(_shoot_pressed)

	timeline_control.setup(self)
	timeline_control.frame_changed.connect(_timeline_control_frame_changed)

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
