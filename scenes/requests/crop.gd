extends Panel

@onready var sprites = [$Sprite2D, $Sprite2D2, $Sprite2D3, $Sprite2D4]

func _ready() -> void :
	#var random_int = 0
	GameFunctions.element_updated.connect(update_crop)
	sprites[GameFunctions.element_index].visible = true
	
func update_crop(element_index):
	print("Index: ", element_index)
	sprites[element_index].visible = true
	
