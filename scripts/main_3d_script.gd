extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mainScene = self
	Global.cardsContainer = self
	
	'''MainLogic.make_available_cards()
	MainLogic.take_card(MainLogic.Entities.PLAYER,"PENTACLES_ACE")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"CUPS_TEN")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"SWORDS_TEN")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"SWORDS_ACE")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"CUPS_TEN")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"CUPS_NINE")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"CUPS_EIGHT")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"CUPS_SIX")
	MainLogic.take_card(MainLogic.Entities.PLAYER,"CUPS_SEVEN")
	
	MainLogic.print_cards(MainLogic.Entities.PLAYER)
	print(MainLogic.get_combination(MainLogic.Entities.PLAYER))'''
	do_one_round()


func do_one_round() -> float:
	MainLogic.make_available_cards()#тусуем карты
	
	MainLogic.take_random_card(MainLogic.Entities.PLAYER,2)#раздаём карты, этап 1
	MainLogic.take_random_card(MainLogic.Entities.ENEMY,2)
	
	
	
	MainLogic.take_random_card(MainLogic.Entities.SHARED,3)#раздаём карты, этап 2
	
	
	
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 3
	
	
	
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 4
	MainLogic.print_cards(MainLogic.Entities.PLAYER)
	MainLogic.print_cards(MainLogic.Entities.ENEMY)
	MainLogic.print_cards(MainLogic.Entities.SHARED)
	print("")
	var combinationA = MainLogic.get_combination(MainLogic.Entities.PLAYER)
	print(combinationA)
	var combinationB = MainLogic.get_combination(MainLogic.Entities.ENEMY)
	print(combinationB)
	var result = MainLogic.compare_combinations(combinationA,combinationB)#считаем результат
	print(result)
	return result
