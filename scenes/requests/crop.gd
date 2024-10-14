extends Panel

@onready var sprites = [$Sprite2D]
var rng = RandomNumberGenerator.new()

func _ready() -> void :
	#var random_int = rng.randi_range(0, 5)
	var random_int = 0
	sprites[random_int].visible = true
