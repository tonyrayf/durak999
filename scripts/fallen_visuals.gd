extends Sprite3D


@export var current_texture : Texture


func change_fallen_sprite(tex: Texture):
	texture = tex
	material_override.set_shader_parameter("albedo_texture", tex)


func _ready() -> void:
	change_fallen_sprite(current_texture)
