extends Node

signal doFold(flag: bool)

var cursor : Node
var mainScene: Node3D
var cardsContainer: Node3D

var current_day : int = 1
var playerHP: float = 100.0
var enemyHP: float = 150.0
var damageMultiplier: float = 1

func play_or_fold() -> bool: #вызывается, ждёт от игрока продолжения игры или сброса карт
	var result : bool = true
	
	if true:
		result = true
	else:
		result = false
	await get_tree().create_timer(0.5).timeout
	return result
	
func _input(event):
	# Проверяем, что нажата клавиша и что это событие "нажатия" (а не отпускания)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_A:
			doFold.emit(false)
		elif event.keycode == KEY_D: 
			doFold.emit(true)
