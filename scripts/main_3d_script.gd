extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mainScene = self
	Global.cardsContainer = self
	
	do_battle()

func do_battle() -> void:
	while true:
		var damage = await do_one_deal()
		if damage>0:#положительный урон-бьём мы
			Global.enemyHP-=damage
		if damage<0:#@отрицательный-бьёт враг
			Global.playerHP+=damage
	
		
		if Global.playerHP <= 0:
			print("lose")
			break
		elif Global.enemyHP <=0:
			print("win")
			break
		else:
			print("PlayerHP =",Global.playerHP,"\tEnemyHP =",Global.enemyHP)

func do_one_deal() -> float:#сыграть одну раздачу
	var playerChoice: bool
	var combinationA: Array
	var combinationB: Array
	var combinationBlank = [[],[],[],[],[],[],[],[],[],[]]
	var result: float
	MainLogic.make_available_cards()#тусуем карты
	
	MainLogic.take_random_card(MainLogic.Entities.PLAYER,2)#раздаём карты, этап 1
	MainLogic.take_random_card(MainLogic.Entities.ENEMY,2)
	playerChoice = await Global.play_or_fold()
	if !playerChoice:
		print("fold")
		combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
		result = 0.2*MainLogic.compare_combinations(combinationBlank,combinationB)
		return result
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,3)#раздаём карты, этап 2
	playerChoice = await Global.play_or_fold()
	if !playerChoice:
		print("fold")
		combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
		result = 0.2*MainLogic.compare_combinations(combinationBlank,combinationB)
		return result
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 3
	playerChoice = await Global.play_or_fold()
	if !playerChoice:
		print("fold")
		combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
		result = 0.2*MainLogic.compare_combinations(combinationBlank,combinationB)
		return result
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 4
	playerChoice = await Global.play_or_fold()
	if !playerChoice:
		print("fold")
		combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
		result = 0.2*MainLogic.compare_combinations(combinationBlank,combinationB)
		return result
		
	combinationA = MainLogic.get_combination(MainLogic.Entities.PLAYER)
	combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
	result = MainLogic.compare_combinations(combinationA,combinationB)#считаем результат
	
	#MainLogic.print_cards(MainLogic.Entities.PLAYER)
	#MainLogic.print_cards(MainLogic.Entities.ENEMY)
	#MainLogic.print_cards(MainLogic.Entities.SHARED)
	#print("")
	#print(combinationA)
	#print(combinationB)
	
	return result
