extends Node2D

@export var item: InvItem
@export var item2: InvItem

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		item = body.check_inv(GameFunctions.element_index)
		item2 = body.check_inv(GameFunctions.element_index2)
		if item:
			var cnt_items = body.remove_item(item)
			if cnt_items:
				GameFunctions.update_delivery(cnt_items, 1)
		if item2:
			var cnt_items2 = body.remove_item(item2)
			if cnt_items2:
				GameFunctions.update_delivery(cnt_items2, 2)
