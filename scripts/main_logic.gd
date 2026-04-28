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
	PAGE, KNIGHT, QUEEN, KING, ACE,
	
	THE_FOOL, THE_MAGICIAN, THE_HIGH_PRIESTESS, THE_EMPRESS, THE_EMPEROR,
	THE_HIEROPHANT, THE_LOVERS, THE_CHARIOT, STRENGTH, THE_HERMIT,
	WHEEL_OF_FORTUNE, JUSTICE, THE_HANGED_MAN, DEATH, TEMPERANCE,
	THE_DEVIL, THE_TOWER, THE_STAR, THE_MOON, THE_SUN,
	JUDGEMENT, THE_WORLD,
}#BLANK1 BLANK2 нужны, чтобы числовое значение карт соответствовало номиналу
#TODO здесь нужно что-то сделать с KNIGHT, он есть в таро, но его нет в покере

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

func _process(delta: float) -> void:
	print_cards(Entities.PLAYER)

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

func get_combination(entityToGet: int) -> Array:#возвращает массив комбинаций сущности, начиная со старшей комбанации
	var current_cards = get_entity_cards(entityToGet)
	var combinations_array = []
	if false:
		combinations_array.append(Combinations.ROYAL_FLUSH)
	if false:
		combinations_array.append(Combinations.STRAIGHT_FLUSH)
	if false:
		combinations_array.append(Combinations.FOUR_OF_A_KIND)
	if false:
		combinations_array.append(Combinations.FULL_HOUSE)
	if false:
		combinations_array.append(Combinations.FLUSH)
	if false:
		combinations_array.append(Combinations.STRAIGHT)
	if false:
		combinations_array.append(Combinations.THREE_OF_A_KIND)
	if false:
		combinations_array.append(Combinations.TWO_PAIRS)
	if false:
		combinations_array.append(Combinations.PAIR)
	if true:
		combinations_array.append(Combinations.HIGH_CARD)
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
