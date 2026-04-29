extends Area3D


var enter : bool = false

@export var active : bool = false
@export var main_anim_player : Node
@export var mesh : Node


func _on_mouse_entered() -> void:
	if not active:
		return
	
	enter = true
	
	mesh.material_overlay.set_shader_parameter("outline_color", Color(1,1,1,1))

func _on_mouse_exited() -> void:
	if not active:
		return
	
	enter = false
	
	mesh.material_overlay.set_shader_parameter("outline_color", Color(1,1,1,0))


func _process(delta: float) -> void:
	if not active:
		return
	
	if Input.is_action_just_pressed("mouse_lb") and enter:
		main_anim_player.play("start_ritual")
		mesh.material_overlay.set_shader_parameter("outline_color", Color(1,1,1,0))
		active = false
