extends Node

enum GameState { PAUSE, DEFEAT, VICTORY, PLAYING }

var current_state = GameState.PLAYING
var can_pause = true

var plant_selected = 1 # 1 carrot 
var n_of_carrots = 0

var n_delivery_carrots = 2
var random_number : int = randi_range(1,20)
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_number = 1
	#random_number = randi_range(1,20)
	pass


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
			pass
			#print("¡Has ganado!")
		GameState.PLAYING:
			pass
			#print("El juego está en progreso")
	pass

@rpc("any_peer","call_local","reliable")
func win_screen()-> void:
	get_tree().change_scene_to_file("res://scenes/ui/win_screen.tscn")

func update_delivery(cnt_items):
	n_delivery_carrots = max(n_delivery_carrots - cnt_items, 0)
	print(n_delivery_carrots)
	if n_delivery_carrots==0 or (Input.is_action_just_pressed("L") and GameFunctions.current_state == GameState.PLAYING) :
		print("HAS GANADO!")
		win_screen()
	
func generate_requests():
	print("Número generado en GameFunctions: ", random_number)
	random_number = rng.randi_range(1, 20)
	
