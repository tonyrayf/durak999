extends Sprite3D


func change_fallen_sprite(tex: Texture):
	texture = tex
	material_override.set_shader_parameter("albedo_texture", tex)


func _ready() -> void:
	pass
	#change_fallen_sprite(load("res://assets/sprites/fallen/asya.png"))
