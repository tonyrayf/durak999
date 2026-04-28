extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mainScene = self
	Global.cardsContainer = self
	
	do_one_deal()

func do_battle() -> void:
	while true:
		var damage = do_one_deal()
		if damage>0:#положительный урон-бьём мы
			Global.EnemyHP-=damage
		if damage<0:#@отрицательный-бьёт враг
			Global.PlayerHP+=damage
	
		
		if Global.playerHP <= 0:
			print("lose")
			break
		elif Global.enemyHP <=0:
			print("win")
			break
		else:
			print("PlayerHP =",Global.playerHP,"\tEnemyHP =",Global.enemyHP)
		
		await get_tree().create_timer(10.0).timeout

func do_one_deal() -> float:#сыграть одну раздачу
	MainLogic.make_available_cards()#тусуем карты
	
	MainLogic.take_random_card(MainLogic.Entities.PLAYER,2)#раздаём карты, этап 1
	MainLogic.take_random_card(MainLogic.Entities.ENEMY,2)
	
	
	
	MainLogic.take_random_card(MainLogic.Entities.SHARED,3)#раздаём карты, этап 2
	
	
	
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 3
	
	
	
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 4
	#MainLogic.print_cards(MainLogic.Entities.PLAYER)
	#MainLogic.print_cards(MainLogic.Entities.ENEMY)
	#MainLogic.print_cards(MainLogic.Entities.SHARED)
	#print("")
	var combinationA = MainLogic.get_combination(MainLogic.Entities.PLAYER)
	#print(combinationA)
	var combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
	#print(combinationB)
	var result = MainLogic.compare_combinations(combinationA,combinationB)#считаем результат
	#print(result)
	return result
