extends Node

enum GameState { PAUSE, DEFEAT, VICTORY, PLAYING }

var current_state = GameState.PLAYING
var can_pause = true

signal delivery_updated(new_count)
var n_delivery_carrots = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func update_delivery(cnt_items):
	n_delivery_carrots = max(n_delivery_carrots - cnt_items, 0)
	print(n_delivery_carrots)
	emit_signal("delivery_updated", n_delivery_carrots)
	if n_delivery_carrots==0:
		print("HAS GANADO!")	
		
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	match current_state:
		GameState.PAUSE:
			pass
			#print("El juego está en pausa")
		GameState.DEFEAT:
			can_pause = false
			get_tree().paused = true
			#get_tree().change_scene_to_file(derrota)
		GameState.VICTORY:
			print("¡Has ganado!")
		GameState.PLAYING:
			pass
			#print("El juego está en progreso")
