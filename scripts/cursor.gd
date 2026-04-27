extends Area2D


func _ready() -> void:
	Global.cursor = self


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
