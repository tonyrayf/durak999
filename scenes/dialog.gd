extends CanvasLayer


@export var full_text : Array = []
@export var typing_speed : float = 0.4
@export var dialog_active : bool = true
@export var kill_dialog : bool = false
@export var idle_blend : float = 0.6 # когда персонаж не говорит затемняем его

# референсы
@export var label : Node
@export var main_char_spr : Node
@export var opp_char_spr : Node
@export var anim_player : Node

var start : bool = true

@export var autostart : bool = false

var current_page : int = 0
var current_text : String = ""
var current_char : float = 0 # какая сейчас по счету буква

@onready var main_char_spr_scale : Vector2 = main_char_spr.scale
@onready var opp_char_spr_scale : Vector2 = main_char_spr.scale
@onready var text_arr = full_text[current_page]
@onready var page_number = len(full_text)
@onready var text_len = len(text_arr[1])


func _ready() -> void:
	if not autostart:
		set_process(false)


func _process(delta: float) -> void:
	if kill_dialog:
		if Global.player:
			Global.player.set_process(true)
			Global.player.set_physics_process(true)
		
		queue_free()
	
	if dialog_active:
		# Эффект печатания
		if current_char < text_len:
			current_char += typing_speed
		
		label.text = text_arr[1].substr(0, int(current_char + 0.99)).replace("\\n", "\n")
		
		if Input.is_action_just_pressed("attack_punch") or Input.is_action_just_pressed("attack_kick"):
			if current_page < page_number - 1:
				if current_char >= text_len:
					current_page += 1
					text_arr = full_text[current_page]
					text_len = len(text_arr[1])
					current_char = 0
				else:
					current_char = text_len + 1
			else:
				label.text = ""
				anim_player.play("end")
