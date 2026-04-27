extends Node3D

enum TarotCard {
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

enum TestCard {
	CARD1, CARD2, CARD3, CARD4, CARD5, CARD6,
}

enum Combinations {
	ROYAL_FLUSH, STRAIGHT_FLUSH, FOUR_OF_A_KIND,
	FULL_HOUSE, FLUSH, STRAIGHT,
	THREE_OF_A_KIND, TWO_PAIRS, PAIR,
	HIGH_CARD
}

enum Entities {
	PLAYER, ENEMY,
}

var player_cards: Array = [] #карты игрока
var enemy_cards: Array = [] #карты врага
#var general_cards: Array = [] #общие(мб будут не нужны)

var availableCards: Array

func _ready() -> void:
	availableCards = Array(TestCard.values())
	availableCards.shuffle()
	take_card(Entities.PLAYER,2)
	take_random_card(Entities.PLAYER,5)

func _process(delta: float) -> void:
	print_cards(Entities.PLAYER)

func take_random_card(entityToTake: int,amount: int=1) -> bool:#берёт в руку сущности amount случайных карт
	var current_cards = get_entity_cards(entityToTake)
	for i in range(amount):
		if availableCards.is_empty():
			return false
		else:
			current_cards.append(availableCards.pop_back())
	return true

func take_card(entityToTake: int,cardID: int) -> bool:#берёт в руку сущности карту cardID
	var current_cards = get_entity_cards(entityToTake)
	if(cardID in availableCards):
		availableCards.erase(cardID)
		current_cards.append(cardID)
		return true
	else:
		return false

func get_combination(entityToGet: int) -> Array:#возвращает комбинации сущности, начиная со старшей
	var current_cards = get_entity_cards(entityToGet)
	
	return []

func get_entity_cards(entity: int) -> Array:#возвращает массив руки для entityToGet
	if(entity==Entities.PLAYER):
		return player_cards
	elif(entity==Entities.ENEMY):
		return enemy_cards
	else:
		return []

func print_cards(entityToTake: int) -> void:
	var current_cards = get_entity_cards(entityToTake)
	print(current_cards)
