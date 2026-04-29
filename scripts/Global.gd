
extends Node

signal doFold(flag: bool)

var cursor : Node
var mainScene: Node3D
var cardsContainer: Node3D

var current_day : int = 1
var playerHP: float = 100.0
var enemyHP: float = 150.0
var damageMultiplier: float = 1

@onready var default_playerHP : float = playerHP
@onready var default_enemyHP : float = enemyHP


func play_or_fold(fold_damage_multiplier: float = 0.2) -> float:#когда вызывается, ждёт пока игрок выберет сбросить или играть
	var result: float#если возвращается -1, значит игрок НЕ СБРОСИЛ. Если возвращается другое число, значит столько нужно нанести игроку 
	
	var doFold:bool = await Global.doFold
	if(!doFold):
		#print("play")
		result = -1
	else:
		print("fold")
		var combinationA = MainLogic.get_combination(MainLogic.Entities.PLAYER)
		var combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
		result = MainLogic.compare_combinations(combinationA,combinationB)
		if result<=0:#если результат < 0, значит комбинация врага была сильнее, мы получаем уменьшенный урон
			result *= fold_damage_multiplier
		else:#если результат > 0, значит наша комбинация при сбросе была сильнее, никто не получает урон
			result = 0
	
	return result
	
#func _input(event):
#	# Проверяем, что нажата клавиша и что это событие "нажатия" (а не отпускания)
#	if event is InputEventKey and event.pressed:
#		if event.keycode == KEY_A:
#			doFold.emit(false)
#		elif event.keycode == KEY_D: 
#			doFold.emit(true)
