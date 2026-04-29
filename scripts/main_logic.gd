extends Node3D

class card:#класс карты
	var suit: int
	var value: int
	var name: String
	var name_extension: String
	
	#var card_scene_preload #= preload("res://scenes/Card.tscn")
	var card_node: Node
	
	func _init(s: int,v: int) -> void:
		self.suit = s
		self.value = v
		get_card_name()

	func get_card_name() -> void:
		self.name = ""
		self.name += Suits.find_key(self.suit)
		self.name += "_"
		self.name += Values.find_key(self.value)
		self.name_extension = self.name+".png"

	var way = "res://assets/spriets/cards/"
	var buffer
	func spawn_card_scene(entityToGet: int) -> void:
		match entityToGet:
			Entities.PLAYER:
				if MainLogic.player_cards.size()==1:
					buffer = Global.mainScene.cards_on_table[0]
					
				elif MainLogic.player_cards.size()==2:
					buffer = Global.mainScene.cards_on_table[1]
					
			Entities.SHARED:
				if MainLogic.shared_cards.size()==1:
					buffer = Global.mainScene.cards_on_table[2]
					
				elif MainLogic.shared_cards.size()==2:
					buffer = Global.mainScene.cards_on_table[3]
					
				elif MainLogic.shared_cards.size()==3:
					buffer = Global.mainScene.cards_on_table[4]
					
				elif MainLogic.shared_cards.size()==4:
					buffer = Global.mainScene.cards_on_table[5]
					
				elif MainLogic.shared_cards.size()==5:
					buffer = Global.mainScene.cards_on_table[6]
					
			Entities.ENEMY:
				if MainLogic.enemy_cards.size()==1:
					buffer = Global.mainScene.cards_on_table[7]
					
				elif MainLogic.enemy_cards.size()==2:
					buffer = Global.mainScene.cards_on_table[8]
					
		if buffer != null:
			buffer.show()
			
			# Натявигаем текстуру
			print(self.name)
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = load("res://assets/sprites/cards/" + self.name_extension)
			mat.uv1_triplanar = true
			mat.uv1_scale = Vector3(0.5, 0.5, 0.5)
			mat.uv1_offset = Vector3(0.5, 0, 0.5)
			
			buffer.mesh.set_surface_override_material(0, mat)
		else:
			print("Ошибка: buffer пуст! Проверь условия size()")
					
class arcane_card extends card:#класс карты арканы !при создании проверять, что создаваемый аркан есть в сделанных!
	func _init(v: int) -> void:
		self.suit = 4
		self.value = value
		get_card_name()
	
	func do_effect() -> bool:
		if self.value not in MainLogic.DONE_HIGH_ARCANES:
			print("Такая аркана не готова(или нет)")
			return false
		if self.value == Values.THE_FOOL:#Возможно, прерывает раздачу(без ущерба)? НЕ УВЕРЕН
			Global.damage_multiplier = 0
			Global.doFold.emit(true)
		elif self.value == Values.THE_MAGICIAN:#обращает слеюущий урон в лечение ВОЗМОЖНО ЗВЕЗДА
			Global.damage_multiplier = -1
			print("маг")
		elif self.value == Values.WHEEL_OF_FORTUNE:#заменить карты(общие/свои?) ВОЗМОЖНО ДУРАК
			var buffer = MainLogic.shared_cards.size()
			MainLogic.shared_cards.clear()
			MainLogic.take_random_card(Entities.PLAYER,buffer)
			print("фортуна")
		elif self.value == Values.THE_HIGH_PRIESTESS:#подсмотреть в карты врага TODO ПОДХОДИТ
			Global.mainScene.get_node("MainAnimationPlayer").play("the_high_priestess")
			print("жрица")
		elif self.value == Values.DEATH:#увеличивает урон в 4 раза ВОЗМОЖНО БАШНЯ
			Global.damage_multiplier = 4
			print("смерть")
			
		for i in range(MainLogic.high_arcanes_cards.size()):
			if MainLogic.high_arcanes_cards[i].value == self.value:
				MainLogic.high_arcanes_cards.pop_at(i)
				break
		free()
		return true
	
	func spawn_card_scene(entityToGet: int) -> void:
		if MainLogic.high_arcanes_cards.size()==1:
			buffer = Global.mainScene.cards_on_table[9]
		elif MainLogic.high_arcanes_cards.size()==2:
			buffer = Global.mainScene.cards_on_table[10]
		elif MainLogic.high_arcanes_cards.size()==3:
			buffer = Global.mainScene.cards_on_table[11]
					
		if buffer != null:
			buffer.show()
			
			# Натявигаем текстуру
			print(self.name)
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = load("res://assets/sprites/cards/" + self.name_extension)
			mat.uv1_triplanar = true
			mat.uv1_scale = Vector3(0.5, 0.5, 0.5)
			mat.uv1_offset = Vector3(0.5, 0, 0.5)
			
			buffer.mesh.set_surface_override_material(0, mat)
		else:
			print("Ошибка: buffer пуст! Проверь условия size()")

enum Suits {
	WANDS, CUPS, SWORDS, PENTACLES, HIGHARCANES,
}#масти карт

enum Values {#значения карт(номинал, достоинство)
	BLANK_0, BLANK_1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN,
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

var DONE_HIGH_ARCANES = [Values.THE_FOOL,Values.THE_MAGICIAN,Values.WHEEL_OF_FORTUNE,Values.THE_HIGH_PRIESTESS,Values.DEATH]

var player_cards: Array[card] = [] #карты игрока
var enemy_cards: Array[card] = [] #карты врага
var shared_cards: Array[card] = [] #общие
var high_arcanes_cards: Array[card] = [] #старшие арканы, карты игрока

var availableCards: Array[card] #перемешанная колода карт, откуда мы их достаём
var availableHighArcanes: Array[card] # колода старших арканов

func make_available_cards(doShuffle: bool=true) -> void:#задаёт availableCards из мастей и номиналов
	availableCards.clear()
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
		await get_tree().create_timer(0.2).timeout
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
		if current_cards.size()<5:
			straight_flag = false
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
	[1000,15,12,#флеш рояль, стрит флеш, четвёрка\
	11.25,10.5,9.75,#фулл хаус, флеш, стрит\
	9,6,6,#тройка, две пары, пара\
	1.5]#старшая карта
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

func make_high_arcanes_cards(doShuffle: bool=true) -> void:#задаёт доступные старшие аркейны
	high_arcanes_cards.clear()
	for i in DONE_HIGH_ARCANES:
		var new_card = arcane_card.new(Suits.HIGHARCANES)
		availableHighArcanes.append(new_card)
	if doShuffle:
		availableHighArcanes.shuffle()

func take_random_high_arcane() -> bool:#берёт в руку старших арканов случайных аркан из колоды арканов
	if availableHighArcanes.is_empty():
		return false
	elif high_arcanes_cards.size() > 3:
		return false
	else:
		high_arcanes_cards.append(availableHighArcanes.pop_back())
		high_arcanes_cards[high_arcanes_cards.size()-1].spawn_card_scene(Entities.PLAYER)
	return true

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
