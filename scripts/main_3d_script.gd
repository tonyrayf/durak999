extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.mainScene = self
	Global.cardsContainer = self
	
	'''MainLogic.make_available_cards()
	MainLogic.take_random_card(MainLogic.Entities.PLAYER,4)
	MainLogic.take_card(MainLogic.Entities.PLAYER,"WANDS_ACE")
	MainLogic.take_random_card(MainLogic.Entities.ENEMY,4)
	MainLogic.take_card(MainLogic.Entities.ENEMY,"SWORDS_ACE")
	MainLogic.print_cards(MainLogic.Entities.PLAYER)
	MainLogic.print_cards(MainLogic.Entities.ENEMY)'''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
