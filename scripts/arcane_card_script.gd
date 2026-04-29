extends "res://scripts/card.gd"


func _on_input_event(camera, event, event_position, normal, shape_idx):
	# Проверяем нажатие левой кнопки мыши
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_card_clicked(event)

func _on_card_clicked(event):
	Global.cardClicked.emit(event,name)
	#print("Карточка",name,"нажата!")
