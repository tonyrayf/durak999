extends Area3D


var enter : bool = false

@export var active : bool = false
@export var phone_trubka : Node
@export var anim_player : Node
@export var main_anim_player : Node

@onready var start_position : Vector3 = phone_trubka.global_position


func _on_mouse_entered() -> void:
	if not active:
		return
	
	enter = true
	anim_player.play("pick_up_trubka")

func _on_mouse_exited() -> void:
	if not active:
		return
	
	enter = false
	anim_player.play("put_trubka")


func _process(delta: float) -> void:
	if not active:
		return
	
	if Input.is_action_just_pressed("mouse_lb") and enter:
		main_anim_player.play("phone_pickup")
		anim_player.play("put_trubka")
		active = false
