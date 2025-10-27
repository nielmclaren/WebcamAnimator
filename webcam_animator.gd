class_name WebcamAnimator
extends Node2D

@export var webcam_manager: WebcamManager
@export var webcam_texture: TextureRect
@export var shoot_button: Button
@export var latest_shot_texture: TextureRect


func _ready() -> void:
	webcam_texture.texture = webcam_manager.get_texture()

	shoot_button.pressed.connect(func() -> void:
		latest_shot_texture.texture = Utils.duplicate_texture(webcam_manager.get_texture())
	)
