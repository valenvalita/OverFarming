extends AudioStreamPlayer

const menu_music = preload("res://Musica/0_Menu_Theme.wav")
const level_1_music = preload("res://Musica/1_Level_Theme.wav")
const level_2_music = preload("res://Musica/2_Level_Theme.wav")
const level_3_music = preload("res://Musica/3_Level_Theme.wav")

func _play_music(music:AudioStream, volume =-30.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()

func play_music_level(x):
	if x == 0:
		_play_music(menu_music)
	elif x == 1:
		_play_music(level_1_music)
	elif x == 2:
		_play_music(level_2_music)
	elif x == 3:
		_play_music(level_3_music)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
