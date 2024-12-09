extends Control

func _ready() -> void:
	MenuMusic.play_music_level(0)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/level_selector.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/creditos.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
