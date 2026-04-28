extends Camera3D


@export var free_look : bool = false
var force_free_look : bool = true
@export var sensitivity : float = 0.005
@export var max_tilt : Vector2 = Vector2(40, 50)        # в градусах

@onready var start_rotation = rotation


func toggle_free_look(active : bool = not free_look) -> void:
	free_look = active
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN if active else Input.MOUSE_MODE_VISIBLE)
	
	if not active:
		# Плавный переход до начального rotation
		var tween = create_tween()
		
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		
		tween.tween_property(self, "rotation", start_rotation, 0.5)


func _ready() -> void:
	max_tilt.x = deg_to_rad(max_tilt.x)
	max_tilt.y = deg_to_rad(max_tilt.y)
	
	toggle_free_look(free_look)


func _process(_delta):
	if not force_free_look:
		if Input.is_action_just_pressed("ui_free_look"):
			toggle_free_look(true)
		elif Input.is_action_just_released("ui_free_look"):
			toggle_free_look(false)
	elif not free_look:
		toggle_free_look(true)
	
	if not free_look:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Вычисляем отклонение от центра (от -0.5 до 0.5)
	var offset = (mouse_pos / viewport_size) - Vector2(0.5, 0.5)
	
	var target_rotation = start_rotation
	target_rotation.x -= offset.y * max_tilt.x
	target_rotation.y -= offset.x * max_tilt.y
	
	rotation = rotation.lerp(target_rotation, 0.1)
