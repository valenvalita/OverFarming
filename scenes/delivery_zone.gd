extends Node2D

@export var item: InvItem

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var cnt_items = body.remove_item(item)
		if cnt_items:
			GameFunctions.update_delivery(cnt_items)
