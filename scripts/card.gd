extends Area3D

var dragging = false


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed



func _process(_delta):
	#print(self.global_position,self.global_rotation_degrees)
	#if dragging:
	#	var mouse_pos = get_viewport().get_mouse_position()
	#	var camera = get_viewport().get_camera_3d()
	#	
	#	# Создаем плоскость на уровне текущей высоты карты
	#	var project_plane = Plane(Vector3.UP, global_position.y)
	#	var ray_origin = camera.project_ray_origin(mouse_pos)
	#	var ray_direction = camera.project_ray_normal(mouse_pos)
	#	
	#	var intersection = project_plane.intersects_ray(ray_origin, ray_direction)
	#	if intersection:
	#		global_position = intersection
	pass
