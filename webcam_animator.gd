class_name WebcamAnimator
extends Node2D

@export var webcam_manager: WebcamManager
@export var webcam_texture: TextureRect
@export var shoot_button: Button
@export var latest_shot_texture: TextureRect
@export var anim_texture: TextureRect
@export var timeline_control: TimelineControl


func _ready() -> void:
	webcam_texture.texture = webcam_manager.get_texture()

	shoot_button.pressed.connect(_shoot_pressed)

	timeline_control.frame_changed.connect(_timeline_control_frame_changed)


func _shoot_pressed() -> void:
	latest_shot_texture.texture = Utils.duplicate_texture(webcam_manager.get_texture())

	timeline_control.write_selected_frames(webcam_manager.get_texture())


func _timeline_control_frame_changed() -> void:
	anim_texture.texture = timeline_control.get_frame_texture()
