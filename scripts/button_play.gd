extends Area2D

var is_cooling_down = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_cooling_down:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Global.doFold.emit(false)
		is_cooling_down = true
		await get_tree().create_timer(1).timeout # Ждем полсекунды
		is_cooling_down = false


func _on_mouse_entered() -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "modulate", Color(0.85, 0.85, 0.85), 0.1)


func _on_mouse_exited() -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
