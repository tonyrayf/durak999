extends Node3D


@export var day_label : Node
@export var anim_player : Node


func play_sound(stream: AudioStream):
	var player = AudioStreamPlayer2D.new()
	get_tree().current_scene.add_child(player)
	player.stream = stream
	player.play()
	player.finished.connect(player.queue_free)
	player.attenuation = 0
	player.max_distance = 99999


func start_day() -> void:
	if day_label:
		day_label.text = "День " + str(Global.current_day)


func start_phone_ringing() -> void:
	anim_player.play("phone_ringing")
