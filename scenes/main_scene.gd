extends Node3D


@export var day_label : Node
@export var anim_player : Node


func start_day() -> void:
	if day_label:
		day_label.text = "День " + str(Global.current_day)


func start_phone_ringing() -> void:
	anim_player.play("phone_ringing")
