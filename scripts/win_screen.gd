extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("any_peer","call_local","reliable")
func main_menu()-> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	

func _on_main_menu_pressed() -> void:
	main_menu()
	rpc("main_menu")


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_next_level_pressed() -> void:
	main_menu()
	rpc("main_menu")
