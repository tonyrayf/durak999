extends Area2D


var dragged : bool = false


func _process(delta: float) -> void:
	if dragged:
		global_position = Global.cursor.global_position


func _on_area_entered(area: Area2D) -> void:
	if area == Global.cursor and Input.is_action_pressed("mouse_lb"):
		dragged = true

func _on_area_exited(area: Area2D) -> void:
	if area == Global.cursor:
		dragged = false
