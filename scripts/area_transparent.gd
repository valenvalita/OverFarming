extends Area2D
@onready var supermarket: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		supermarket.modulate = Color(1, 1, 1, 0.5)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		supermarket.modulate = Color(1, 1, 1, 1)
