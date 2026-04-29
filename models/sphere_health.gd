extends Node3D


@export var omni_light : Node
@export var sphere_mesh : Node
@export var player_advantage_color : Color = Color(0.627, 0.83, 1.042)
@export var enemy_advantage_color : Color = Color(0.865, 0.285, 0.309)
@export var neutral_advantage_color : Color = Color(0.667, 0.667, 0.667)

@onready var current_color : Color = neutral_advantage_color


func set_light(color: Color, brightness: float = 1) -> void:
	omni_light.light_color = color
	var mat = sphere_mesh.get_surface_override_material(1)
	
	if mat:
		mat.albedo_color = Color(color, 0.6)
		mat.emission = color
		mat.emission_energy_multiplier = brightness


func _ready() -> void:
	set_light(current_color, 1)


func _process(delta: float) -> void:
	# Считаем разницу HP
	var playerHP_multi : float = Global.playerHP / Global.default_playerHP
	var enemyHP_multi : float = Global.enemyHP / Global.default_enemyHP
	
	# advantage будет в диапазоне от -1.0 до 1.0
	var advantage = playerHP_multi - enemyHP_multi
	
	var final_color : Color
	
	if advantage > 0:
		# Смешиваем от нейтрального к синему
		final_color = neutral_advantage_color.lerp(player_advantage_color, advantage)
	elif advantage < 0:
		# Смешиваем от нейтрального к красному		
		final_color = neutral_advantage_color.lerp(enemy_advantage_color, abs(advantage))
	else:
		final_color = neutral_advantage_color
	
	# Применяем полученный цвет
	set_light(final_color)
	
	if advantage <= -0.95:
		Global.mainScene.get_node("MainAnimationPlayer").play("death")
	elif advantage >= 0.95:
		Global.current_day += 1
		get_tree().change_scene_to_file("res://scenes/Main3D" + str(Global.current_day) + ".tscn")
		set_process(false)
