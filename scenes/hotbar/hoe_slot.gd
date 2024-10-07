extends Panel

var selectorClass = preload("res://scenes/hotbar/selector.tscn")
var selector = null

func isSelected() -> void:
	selector = selectorClass.instantiate()
	add_child(selector)
	selector.position = $Sprite2D2.position
	
func notSelected() -> void:
	remove_child(selector)
