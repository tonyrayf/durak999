extends Sprite2D

var can_click: bool = true

func _ready():
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = texture.get_size()
	collision.shape = rect
	area.add_child(collision)
	add_child(area)
	area.input_event.connect(_on_click)

func _on_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and can_click:
		can_click = false
		
		# Переключаем режим
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		# Обновляем глобальную переменную
		Settings.is_fullscreen = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		# Защита от повторного нажатия
		await get_tree().create_timer(0.3).timeout
		can_click = true
