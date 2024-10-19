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
	random_number = 10
	#random_number = randi_range(1,20)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		GameState.PAUSE:
			print("El juego está en pausa")
		GameState.DEFEAT:
			can_pause = false
			get_tree().paused = true
			#get_tree().change_scene_to_file(derrota)
		GameState.VICTORY:
			print("¡Has ganado!")
		GameState.PLAYING:
			pass
			#print("El juego está en progreso")
	pass

func update_delivery(cnt_items):
	n_delivery_carrots = max(n_delivery_carrots - cnt_items, 0)
	print(n_delivery_carrots)
	if n_delivery_carrots==0:
		print("HAS GANADO!")
	
func generate_requests():
	print("Número generado en GameFunctions: ", random_number)
	random_number = rng.randi_range(1, 20)
	
