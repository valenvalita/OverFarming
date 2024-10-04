extends Control



func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func TestEsc():
	if GameFunctions.can_pause:
		if Input.is_action_just_pressed("esc") and !get_tree().paused:
			pause()
		elif Input.is_action_just_pressed("esc") and get_tree().paused:
			resume()

func _process(delta):
	TestEsc()


func _on_reanude_pressed() -> void:
	resume()
	
	
func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
