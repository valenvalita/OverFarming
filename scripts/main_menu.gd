extends Control

func _ready() -> void:
	MenuMusic.play_music_level(0)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
