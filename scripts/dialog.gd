extends Node2D


const colors : Array = \
	[
		Color(1.0, 1.0, 1.0, 1.0),		# цвет закзчика
		Color(0.618, 0.699, 0.972, 1.0),	# цвет гг
		Color(0.262, 0.725, 0.556, 1.0),	# цвет духа
	]

@export var full_text : Array[String] = []
@export var typing_speed : float = 0.3
@export var autostart : bool = true
@export var function_name : String = ""
var destroy_func : Callable

# референсы
@export var label : Node
@export var main_chara_voice : Node
@export var opponent_voice : Node

var current_page : int = 0
var current_char : float = 0 # какая сейчас по счету буква
var last_char_index : int = 0

@onready var current_text : String = full_text[current_page]
@onready var page_number : int = len(full_text)
@onready var text_len : int = len(current_text)


func call_selected_main_function(function_name : String):
	var main = get_tree().current_scene
	if main.has_method(function_name):
		main.call(function_name)


func _get_ready() -> void:
	current_text = full_text[current_page]
	page_number = len(full_text)
	text_len = len(current_text)


func _ready() -> void:
	if not autostart:
		set_process(false)


func _process(delta: float) -> void:
	# Эффект печатания
	if current_char < text_len:
		current_char += typing_speed
		
		if current_text[0] == "1":
			if not main_chara_voice.playing:
				main_chara_voice.playing = true
		elif not opponent_voice.playing:
			opponent_voice.playing = true
	else:
		main_chara_voice.playing = false
		opponent_voice.playing = false
	
	label.text = current_text.substr(1, int(current_char + 0.99))
	label.label_settings.font_color = colors[int(current_text[0])]
	
	if Input.is_action_just_pressed("mouse_lb"):
		if current_page < page_number - 1:
			# Новый пэйдж
			if current_char >= text_len:
				current_page += 1
				current_text = full_text[current_page]
				text_len = len(current_text)
				current_char = 0
			# Пропуск предложения
			else:
				current_char = text_len + 1
		else:
			label.text = ""
			call_selected_main_function(function_name)
			current_page = 0
			current_char = 0
			current_text = ""
	
			set_process(false)
