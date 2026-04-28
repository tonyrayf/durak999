extends Area3D


@export var phone_trubka : Node
@export var anim_player : Node

@onready var start_position : Vector3 = phone_trubka.global_position


func _on_mouse_entered() -> void:
	anim_player.play("pick_up_trubka")

func _on_mouse_exited() -> void:
	anim_player.play("put_trubka")
