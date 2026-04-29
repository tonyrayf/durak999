extends Sprite2D

func _ready():
	# Создаём кликабельную область
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = texture.get_size()
	collision.shape = rect_shape
	area.add_child(collision)
	add_child(area)
	area.input_event.connect(_on_click)

func _on_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://scenes/Main3D.tscn")
