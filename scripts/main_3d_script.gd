extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mainScene = self
	Global.cardsContainer = self
	
	do_battle()

func do_battle() -> void:
	MainLogic.make_high_arcanes_cards()
	while true:
		MainLogic.take_random_high_arcane()
		var damage = await do_one_deal()
		if damage>0:#положительный урон-бьём мы
			print("we damage")
			Global.enemyHP-=damage*Global.damage_multiplier
		elif damage<0:#@отрицательный-бьёт враг
			print("enemy damages")
			Global.playerHP+=damage*Global.damage_multiplier
		else:
			print("no damage(draw on our hand better at fold)")
			
		if Global.damage_multiplier != 1:
				Global.damage_multiplier = 1
	
		if Global.playerHP <= 0:
			print("lose")
			break
		elif Global.enemyHP <=0:
			print("win")
			break
		else:
			print("PlayerHP =",Global.playerHP,"\tEnemyHP =",Global.enemyHP)

func do_one_deal() -> float:#сыграть одну раздачу
	var damage_buffer: float
	var result: float
	MainLogic.make_available_cards()#тусуем карты
	
	MainLogic.take_random_card(MainLogic.Entities.PLAYER,2)#раздаём карты, этап 1
	MainLogic.take_random_card(MainLogic.Entities.ENEMY,2)
	damage_buffer = await play_or_fold()#даём возможность сбросить
	if damage_buffer!=-1:
		return damage_buffer
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,3)#раздаём карты, этап 2
	damage_buffer = await play_or_fold()#даём возможность сбросить
	if damage_buffer!=-1:
		return damage_buffer
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 3
	damage_buffer = await play_or_fold()#даём возможность сбросить
	if damage_buffer!=-1:
		return damage_buffer
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 4
	damage_buffer = await play_or_fold()#даём возможность сбросить
	if damage_buffer!=-1:
		return damage_buffer
		
	var combinationA = MainLogic.get_combination(MainLogic.Entities.PLAYER)
	var combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
	result = MainLogic.compare_combinations(combinationA,combinationB)#считаем результат
	
	MainLogic.print_cards(MainLogic.Entities.PLAYER)
	MainLogic.print_cards(MainLogic.Entities.ENEMY)
	MainLogic.print_cards(MainLogic.Entities.SHARED)
	#print("")
	#print(combinationA)
	#print(combinationB)
	
	return result
	
#!!!ЗАГОТОВКА!!!
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
