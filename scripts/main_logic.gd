extends Node3D

class card:#класс карты
	var suit: int
	var value: int
	var name: String
	var name_extension: String
	
	var card_scene_preload #= preload("res://scenes/Card.tscn")
	var card_scene
	
	func _init(s: int,v: int) -> void:
		self.suit = s
		self.value = v
		get_card_name()

	func get_card_name() -> void:
		self.name = ""
		self.name += Suits.find_key(self.suit)
		self.name += "_"
		self.name += Values.find_key(self.value)
		self.name_extension = self.name+".jpg"

	func spawn_card_scene(entityToGet: int) -> void:
		var card_scene = load("res://scenes/Card.tscn")
		
		if not card_scene:
			push_error("Не найдена сцена карты")
			return
		
		var card_node = card_scene.instantiate()
		
		match entityToGet:
			Entities.PLAYER:
				card_node.global_position = Vector3(0, 0, 0)
			
			Entities.SHARED:
				card_node.global_position = Vector3(0, 0, -3)
			
			Entities.ENEMY:
				card_node.global_position = Vector3(0, 0, -6)
		
		Global.mainScene.add_child(card_node)
		#Global.cardsContainer.add_child(card_scene)
		#return card_scene
		

enum Suits {
	WANDS, CUPS, SWORDS, PENTACLES, HIGHARCANES,
}#масти карт

enum Values {#значения карт(номинал, достоинство)
	BLANK_0, BLANK_1, TWO, THREE, FOUR, FIFE, SIX, SEVEN, EIGHT, NINE, TEN,
	PAGE, QUEEN, KING, ACE,
	
	THE_FOOL, THE_MAGICIAN, THE_HIGH_PRIESTESS, THE_EMPRESS, THE_EMPEROR,
	THE_HIEROPHANT, THE_LOVERS, THE_CHARIOT, STRENGTH, THE_HERMIT,
	WHEEL_OF_FORTUNE, JUSTICE, THE_HANGED_MAN, DEATH, TEMPERANCE,
	THE_DEVIL, THE_TOWER, THE_STAR, THE_MOON, THE_SUN,
	JUDGEMENT, THE_WORLD,
}#BLANK1 BLANK2 нужны, чтобы числовое значение карт соответствовало номиналу
#KNIGHT должен быть между PAGE И QUEEN, но его нет в покере

enum Combinations {#перечисление комбинаций
	ROYAL_FLUSH, STRAIGHT_FLUSH, FOUR_OF_A_KIND,
	FULL_HOUSE, FLUSH, STRAIGHT,
	THREE_OF_A_KIND, TWO_PAIRS, PAIR,
	HIGH_CARD
}

enum Entities {#перечесление владельцов карт
	PLAYER, ENEMY, SHARED
}

var player_cards: Array[card] = [] #карты игрока
var enemy_cards: Array[card] = [] #карты врага
var shared_cards: Array[card] = [] #общие

var availableCards: Array[card] #перемешанная колода карт, откуда мы их достаём

func make_available_cards(doShuffle: bool=true) -> void:#задаёт availableCards из мастей и номиналов
	player_cards.clear()
	enemy_cards.clear()
	shared_cards.clear()
	for i in range(Suits.WANDS,Suits.PENTACLES+1):
		for j in range(Values.TWO,Values.ACE+1):
			var new_card = card.new(i,j)
			availableCards.append(new_card)
	if(doShuffle):
		availableCards.shuffle()

func take_random_card(entityToGet: int,amount: int=1) -> bool:#берёт в руку сущности amount случайных карт
	var current_cards = get_entity_cards(entityToGet)
	for i in range(amount):
		if availableCards.is_empty():
			return false
		else:
			current_cards.append(availableCards.pop_back())
			current_cards[current_cards.size()-1].spawn_card_scene(entityToGet)
	return true

func take_card(entityToGet: int,cardName: String) -> bool:#берёт в руку сущности карту cardID
	var current_cards = get_entity_cards(entityToGet)
	var found_index = -1
	for i in range(availableCards.size()):
		if availableCards[i].name == cardName:
			found_index = i
			break
	if found_index == -1:
		return false
	else:
		current_cards.append(availableCards[found_index])
		availableCards.remove_at(found_index)
		current_cards[current_cards.size()-1].spawn_card_scene(entityToGet)
		return true

func get_combination(entityToGet: int) -> Array:#возвращает массив комбанций в следующем виде:
	#индекс массива-номер комбинации, от старшей к младшей
	#по индексу лежит массив, хранящий в себе по порядку номера, на которых карты лежат в руке
	#если массив по индексу пустой, комбинации нет
	var current_cards = get_entity_cards(entityToGet,true)
	var combinations_array: Array = []
	combinations_array.resize(Combinations.size())
	
	for i in range(combinations_array.size()):#заполняем пустые сочетания пустыми массивами
		combinations_array[i] = [] 
	
	var all_indices = range(current_cards.size())#сортируем карты по значению
	all_indices.sort_custom(func(a, b): return current_cards[a].value > current_cards[b].value)
	
	#var toPrint: String = ""#печатаем сортированные
	#for i in all_indices:
	#	toPrint+=current_cards[i].name
	#	toPrint+=" "
	#print(toPrint)
	
	var quadruplets = []#считаем четвёрки тройки пары
	var triplets = []
	var pairs = []
	
	var first_in_line_value = 0
	var counter_value = 1
	var current_value = current_cards[all_indices[0]].value
	for i in range(1,all_indices.size()):
		if current_cards[all_indices[i]].value == current_value:
			counter_value+=1
		else:
			if counter_value == 2:
				pairs.append(first_in_line_value)
			elif counter_value == 3:
				triplets.append(first_in_line_value)
			elif counter_value == 4:
				quadruplets.append(first_in_line_value)
			
			first_in_line_value = i
			counter_value = 1
			current_value = current_cards[all_indices[i]].value
	if counter_value == 2:
		pairs.append(first_in_line_value)
	elif counter_value == 3:
		triplets.append(first_in_line_value)
	elif counter_value == 4:
		quadruplets.append(first_in_line_value)
	
	if false:#для флеш(клеш) рояля
		combinations_array[MainLogic.Combinations.ROYAL_FLUSH] = []
	elif false:#для стрит флеша
		combinations_array[MainLogic.Combinations.STRAIGHT_FLUSH] = []
	elif pairs.size() == 0 and triplets.size() == 0 and quadruplets.size() == 1:#для четвёрки
		combinations_array[MainLogic.Combinations.FOUR_OF_A_KIND] =\
		[all_indices[quadruplets[0]],all_indices[quadruplets[0]+1],all_indices[quadruplets[0]+2],all_indices[quadruplets[0]+3]]
	elif pairs.size() == 1 and triplets.size() == 1 and quadruplets.size() == 0:#для фулл-хауса
		combinations_array[MainLogic.Combinations.FULL_HOUSE] =\
		[all_indices[triplets[0]],all_indices[triplets[0]+1],all_indices[triplets[0]+2],all_indices[pairs[0]],all_indices[pairs[0]+1]]
		
	elif pairs.size() == 0 and triplets.size() == 1 and quadruplets.size() == 0:#для тройки
		combinations_array[MainLogic.Combinations.THREE_OF_A_KIND] =\
		[all_indices[triplets[0]],all_indices[triplets[0]+1],all_indices[triplets[0]+2]]
	elif pairs.size() == 2 and triplets.size() == 0 and quadruplets.size() == 0:#для двух пар
		combinations_array[MainLogic.Combinations.TWO_PAIRS] =\
		[all_indices[pairs[0]],all_indices[pairs[0]+1],all_indices[pairs[1]],all_indices[pairs[1]+1]]
	elif pairs.size() == 1 and triplets.size() == 0 and quadruplets.size() == 0:#для пары
		combinations_array[MainLogic.Combinations.PAIR] =\
		[all_indices[pairs[0]],all_indices[pairs[0]+1]]
	
	if pairs.size() == 0 and triplets.size() == 0 and quadruplets.size() == 0:
		var current_suit = current_cards[0].suit
		var flush_flag = true
		for i in range(1,current_cards.size()):
			if current_cards[i].suit != current_suit:
				flush_flag = false
				break
			
		var first_value = current_cards[all_indices[0]].value#для стрита
		var straight_flag = true
		for i in range(1,current_cards.size()):
			if current_cards[all_indices[i]].value != first_value-i:
				straight_flag = false
				break

		if straight_flag and flush_flag:#для стрит-флеша
			combinations_array[MainLogic.Combinations.STRAIGHT_FLUSH] =\
			[all_indices[0],all_indices[1],all_indices[2],all_indices[3],all_indices[4]]
		elif flush_flag:#для флеша
			combinations_array[MainLogic.Combinations.FLUSH] =\
			[0,1,2,3,4]
		elif straight_flag:#для стрита
			combinations_array[MainLogic.Combinations.STRAIGHT] =\
			[all_indices[0],all_indices[1],all_indices[2],all_indices[3],all_indices[4]]
	
	#для старшей карты
	var maxHighCardValue = 0
	for i in range(1,current_cards.size()):
		if current_cards[maxHighCardValue].value < current_cards[i].value:
			maxHighCardValue = i
	combinations_array[MainLogic.Combinations.HIGH_CARD] = [maxHighCardValue]
		
	return combinations_array

func compare_combinations(combinationA: Array,combinationB: Array) -> float:#сравнивает по силе две комбинации
	#если A сильнее, возвращается число >0
	#если B сильнее, возвращается число <0
	#это число-урон в зависимости от весов разных комбинаций и старших карт этих комбинаций]
	var current_cards_A = get_entity_cards(Entities.PLAYER,true)
	var current_cards_B = get_entity_cards(Entities.ENEMY,true)
	var damage: float = 0.0
	var combination_damage_multiplier =\
	[1000,5,4,#флеш рояль, стрит флеш, четвёрка\
	3.75,3.5,3.25,#фулл хаус, флеш, стрит\
	3,2,2,#тройка, две пары, пара\
	0.5]#старшая карта
	var i = 0
	while i<=Combinations.HIGH_CARD:
		if not combinationA[i].is_empty():
			damage += current_cards_A[combinationA[i][0]].value*combination_damage_multiplier[i]
		if not combinationB[i].is_empty():
			damage -= current_cards_B[combinationB[i][0]].value*combination_damage_multiplier[i]
		i+=1
		#print(damage)
	return damage

func get_entity_cards(entity: int,doShared=false) -> Array[card]:#возвращает массив карт в руке для entityToGet
	if(entity==Entities.PLAYER):
		if doShared:
			return player_cards+shared_cards
		else:
			return player_cards
	elif(entity==Entities.ENEMY):
		if doShared:
			return enemy_cards+shared_cards
		else:
			return enemy_cards
	elif(entity==Entities.SHARED):
		return shared_cards
	else:
		return []


func print_cards(entityToGet: int) -> void:#тупо print, чё
	var current_cards = get_entity_cards(entityToGet)
	var toPrint: String = ""
	for i in current_cards:
		toPrint+=i.name
		toPrint+=" "
	print(toPrint)

enum TarotCard {#тупо все карты таро
	# Major Arcana (Старшие арканы)
	THE_FOOL, THE_MAGICIAN, THE_HIGH_PRIESTESS, THE_EMPRESS, THE_EMPEROR,
	THE_HIEROPHANT, THE_LOVERS, THE_CHARIOT, STRENGTH, THE_HERMIT,
	WHEEL_OF_FORTUNE, JUSTICE, THE_HANGED_MAN, DEATH, TEMPERANCE,
	THE_DEVIL, THE_TOWER, THE_STAR, THE_MOON, THE_SUN,
	JUDGEMENT, THE_WORLD,

	# Wands (Жезлы)
	WANDS_ACE, WANDS_2, WANDS_3, WANDS_4, WANDS_5, WANDS_6, WANDS_7,
	WANDS_8, WANDS_9, WANDS_10, WANDS_PAGE, WANDS_KNIGHT, WANDS_QUEEN, WANDS_KING,

	# Cups (Кубки)
	CUPS_ACE, CUPS_2, CUPS_3, CUPS_4, CUPS_5, CUPS_6, CUPS_7,
	CUPS_8, CUPS_9, CUPS_10, CUPS_PAGE, CUPS_KNIGHT, CUPS_QUEEN, CUPS_KING,

	# Swords (Мечи)
	SWORDS_ACE, SWORDS_2, SWORDS_3, SWORDS_4, SWORDS_5, SWORDS_6, SWORDS_7,
	SWORDS_8, SWORDS_9, SWORDS_10, SWORDS_PAGE, SWORDS_KNIGHT, SWORDS_QUEEN, SWORDS_KING,

	# Pentacles (Пентакли)
	PENTACLES_ACE, PENTACLES_2, PENTACLES_3, PENTACLES_4, PENTACLES_5, PENTACLES_6, PENTACLES_7,
	PENTACLES_8, PENTACLES_9, PENTACLES_10, PENTACLES_PAGE, PENTACLES_KNIGHT, PENTACLES_QUEEN, PENTACLES_KING
}
