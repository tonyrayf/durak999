extends Node3D

class card:#класс карты
	var suit: int
	var value: int
	var name: String
	var name_extension: String
	
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
	PLAYER, ENEMY,
}

var player_cards: Array[card] = [] #карты игрока
var enemy_cards: Array[card] = [] #карты врага
#var general_cards: Array[card] = [] #общие(мб будут не нужны)

var availableCards: Array[card] #перемешанная колода карт, откуда мы их достаём

func _ready() -> void:
	make_available_cards()
	take_card(Entities.PLAYER,"WANDS_ACE")
	take_random_card(Entities.PLAYER,5)
	
	print_cards(Entities.PLAYER)
	take_card(Entities.PLAYER,"SWORDS_TEN")
	print_cards(Entities.PLAYER)
	

func _process(delta: float) -> void:
	#print_cards(Entities.PLAYER)
	pass

func make_available_cards(doShuffle: bool=true) -> void:#задаёт availableCards из мастей и номиналов
	for i in range(Suits.WANDS,Suits.PENTACLES+1):
		for j in range(Values.TWO,Values.ACE+1):
			var new_card = card.new(i,j)
			availableCards.append(new_card)
	if(doShuffle):
		availableCards.shuffle()

func take_random_card(entityToTake: int,amount: int=1) -> bool:#берёт в руку сущности amount случайных карт
	var current_cards = get_entity_cards(entityToTake)
	for i in range(amount):
		if availableCards.is_empty():
			return false
		else:
			current_cards.append(availableCards.pop_back())
	return true

func take_card(entityToTake: int,cardName: String) -> bool:#берёт в руку сущности карту cardID
	var current_cards = get_entity_cards(entityToTake)
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
		return true

#!!!ТОЛЬКО ЗАГОТОВКА!!!
func get_combinations(entityToGet: int) -> Array:#возвращает массив комбанций в следующем виде:
	#индекс массива-номер комбинации, от старшей к младшей
	#по индексу лежит массив, хранящий в себе по порядку номера, на которых карты лежат в руке
	var current_cards = get_entity_cards(entityToGet)
	var combinations_array: Array = []
	combinations_array.resize(Combinations.size())
	
	for i in range(combinations_array.size()):
		combinations_array[i] = [] 

	# 1. Группировка по номиналам (для Пары, Сета, Каре, Фулл-хауса)
	var counts = {} # Номинал -> [индексы]
	for i in range(current_cards.size()):
		var v = current_cards[i].value
		if not counts.has(v): counts[v] = []
		counts[v].append(i)

	# 2. Сбор всех пар (пример)
	var all_pairs = []
	for v in counts:
		if counts[v].size() == 2:
			all_pairs.append_array(counts[v])
	if all_pairs.size() >= 2:
		# Логика для TWO_PAIRS (нужно отобрать 4 индекса лучших двух пар)
		pass
	elif all_pairs.size() == 1:
		combinations_array[Combinations.PAIR] = all_pairs

	# 3. Старшая карта (High Card) — записываем ВСЕ позиции, от лучшей к худшей
	var sorted_indices = range(current_cards.size())
	sorted_indices.sort_custom(func(a, b): 
		return current_cards[a].value > current_cards[b].value
	)
	combinations_array[Combinations.HIGH_CARD] = sorted_indices

	return combinations_array

func get_entity_cards(entity: int) -> Array[card]:#возвращает массив карт в руке для entityToGet
	if(entity==Entities.PLAYER):
		return player_cards
	elif(entity==Entities.ENEMY):
		return enemy_cards
	else:
		return []

func print_cards(entityToTake: int) -> void:#тупо print, чё
	var current_cards = get_entity_cards(entityToTake)
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
