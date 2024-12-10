extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameFunctions.current_state = GameFunctions.GameState.PAUSE
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().paused = false

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/creditos.tscn")
