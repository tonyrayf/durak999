extends Area2D


var entered : bool = false
var dragging : bool = false


func _process(delta: float) -> void:
	if entered:
		if Input.is_action_pressed("mouse_lb"):
			dragging = true
		else:
			dragging = false
	
	if dragging:
		global_position = Global.cursor.global_position


func _on_area_entered(area: Area2D) -> void:
	if area == Global.cursor:
		entered = true

func _on_area_exited(area: Area2D) -> void:
	if area == Global.cursor:
		entered = false
		dragging = false
