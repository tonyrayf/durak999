extends Node3D


@export var day_label : Node
@export var anim_player : Node

var cards_on_table


func play_sound(stream: AudioStream):
	var player = AudioStreamPlayer2D.new()
	get_tree().current_scene.add_child(player)
	player.stream = stream
	player.play()
	player.finished.connect(player.queue_free)
	player.attenuation = 0
	player.max_distance = 99999


func start_day() -> void:
	if day_label:
		day_label.text = "День " + str(Global.current_day)


func start_phone_ringing() -> void:
	anim_player.play("phone_ringing")


func start_phone_dialog_over() -> void:
	anim_player.play("phone_dialog_over")


func start_game_start() -> void:
	do_battle()
	anim_player.play("game_start")


func _ready() -> void:
	Global.mainScene = self
	Global.cardsContainer = self
	cards_on_table = [$Card1, $Card2,$Card3,$Card4,$Card5,$Card6,$Card7,$Card8,$Card9]
	
	for i in cards_on_table:
		i.hide()
	#print(Global.mainScene.cards_on_table)


func do_battle() -> void:
	MainLogic.make_high_arcanes_cards()
	while true:
		for i in cards_on_table:
			i.hide()
		MainLogic.take_random_high_arcane()
		var damage = await do_one_deal()
		if damage>0:#положительный урон-бьём мы
			print("we damage")
			Global.enemyHP-=damage*Global.damageMultiplier
		elif damage<0:#@отрицательный-бьёт враг
			print("enemy damages")
			Global.playerHP+=damage*Global.damageMultiplier
		else:
			print("no damage(draw on our hand better at fold)")
			
		if Global.damageMultiplier != 1:
				Global.damageMultiplier = 1
	
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
	print("flop")
	damage_buffer = await Global.play_or_fold()#даём возможность сбросить
	if damage_buffer!=-1:
		return damage_buffer

		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,3)#раздаём карты, этап 2
	damage_buffer = await Global.play_or_fold()#даём возможность сбросить
	print("turn")
	if damage_buffer!=-1:
		return damage_buffer
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 3
	damage_buffer = await Global.play_or_fold()#даём возможность сбросить
	print("river")
	if damage_buffer!=-1:
		return damage_buffer
		
	MainLogic.take_random_card(MainLogic.Entities.SHARED,1)#раздаём карты, этап 4
	damage_buffer = await Global.play_or_fold()#даём возможность сбросить
	print("showdown")
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
