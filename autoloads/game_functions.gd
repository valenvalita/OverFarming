extends Node

enum GameState { PAUSE, DEFEAT, VICTORY, PLAYING }

var current_state = GameState.PLAYING
var can_pause = true
var rng = RandomNumberGenerator.new()

# { id: Item }
var item_data := {}
var item_data_path := "res://inventory/items"

signal element_updated(element)
@export var element_index = rng.randi_range(0,3):
	set(val):
		element_index = val
		element_updated.emit(element_index)
		
signal element_updated2(element)
@export var element_index2 = generate_different_random(element_index, 0, 3):
	set(val):
		element_index2 = val
		element_updated2.emit(element_index2)

signal delivery_updated(new_count)
#@export var n_delivery_carrots = rng.randi_range(1, 20):
@export var n_delivery_carrots = 3:
	set(value): 
		n_delivery_carrots = value
		print("Actualiza valor a: ", n_delivery_carrots)
		delivery_updated.emit(n_delivery_carrots)

signal delivery_updated2(new_count)
#@export var n_delivery_carrots2 = generate_different_random(n_delivery_carrots, 1, 20):
@export var n_delivery_carrots2 = 3:
	set(value): 
		n_delivery_carrots2 = value
		print("Actualiza valor a: ", n_delivery_carrots2)
		delivery_updated2.emit(n_delivery_carrots2)

func generate_different_random(num : int, min : int, max : int) -> int :
	var res = rng.randi_range(min,max)
	while(res == num):
		res = rng.randi_range(min,max)
	return res


@rpc("any_peer","call_local","reliable")
func win_screen()-> void:
	get_tree().change_scene_to_file("res://scenes/ui/win_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_data()

func update_delivery(cnt_items, index):
	update_delivery_server.rpc_id(1, cnt_items, index)
		
@rpc("any_peer", "call_local")
func update_delivery_server(cnt_items, index):
	if index == 1:
		n_delivery_carrots = max(n_delivery_carrots - cnt_items, 0)
	elif index == 2:
		n_delivery_carrots2 = max(n_delivery_carrots2 - cnt_items, 0)
		
	if n_delivery_carrots==0 and n_delivery_carrots2==0:
		print("HAS GANADO!")
		win_screen.rpc()
	
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
func load_data():
	var dir = DirAccess.open(item_data_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var id = file_name.split(".")[0]
				Debug.log("Item added: " + id)
				item_data[id] = load("%s/%s" % [item_data_path, file_name] )
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

#@rpc("any_peer","call_local","reliable")
#func win_screen()-> void:
#	get_tree().change_scene_to_file("res://scenes/ui/win_screen.tscn")
