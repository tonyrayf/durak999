extends Node


var cursor : Node
var mainScene: Node3D
var cardsContainer: Node3D

var current_day : int = 1
var playerHP: float = 100.0
var enemyHP: float = 150.0

func play_or_fold() -> bool: #вызывается, ждёт от игрока продолжения игры или сброса карт
	var result : bool = true
	
	if true:
		result = true
	else:
		result = false
	await get_tree().create_timer(0.5).timeout
	return result
