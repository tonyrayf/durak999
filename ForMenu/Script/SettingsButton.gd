extends Sprite2D

var camera: Camera2D
var target_x: float
var is_moving: bool = false
var speed: float = 5.0

func _ready():
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = texture.get_size()
	collision.shape = rect_shape
	area.add_child(collision)
	add_child(area)
	area.input_event.connect(_on_click)
	
	camera = get_node("../Camera2D")

func _process(delta):
	if is_moving:
		camera.position.x = move_toward(camera.position.x, target_x, speed * 5000 * delta)
		if camera.position.x == target_x:
			is_moving = false

func _on_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_moving:
			target_x = camera.position.x + 2000
			is_moving = true
