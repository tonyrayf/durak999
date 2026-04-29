extends HSlider

func _ready():
	min_value = 0
	max_value = 1
	step = 0.01
	value = Settings.master_volume
	value_changed.connect(_on_value_changed)

func _on_value_changed(value):
	Settings.master_volume = value
