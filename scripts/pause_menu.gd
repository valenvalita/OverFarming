extends Control

var is_paused = false
@rpc("any_peer","call_local","reliable")
func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	is_paused = false 

@rpc("any_peer","call_local","reliable")
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	is_paused = true


func TestEsc():
	if GameFunctions.can_pause:
		if Input.is_action_just_pressed("esc") and !get_tree().paused:
			pause.rpc()
			#rpc("pause")
		elif Input.is_action_just_pressed("esc") and get_tree().paused:
			resume.rpc()
			#rpc("resume")

@warning_ignore("unused_parameter")
func _process(delta):
	TestEsc()

func _on_reanude_pressed() -> void:
	if is_paused:
		resume()

func _on_main_menu_pressed() -> void:
	if is_paused:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_quit_pressed() -> void:
	if is_paused:
		get_tree().quit()
