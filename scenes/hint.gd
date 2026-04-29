extends Label


func set_visibility(is_visible: bool) -> void:
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "modulate", Color(modulate, 1) if is_visible else Color(modulate, 0), 0.2)
