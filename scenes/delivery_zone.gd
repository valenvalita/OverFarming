extends Node2D

@export var item: InvItem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var cnt_items = body.remove_item(item)
		if cnt_items:
			GameFunctions.update_delivery(cnt_items)