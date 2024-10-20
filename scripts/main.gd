extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players
@onready var markers: Node2D = $Markers
@onready var time: Control = $CanvasLayer/Time
var seconds = 0
var minutes = 0
var Dseconds = 10
var Dminutes = 0

@rpc("any_peer","call_local","reliable")
func lose_screen()-> void:
	get_tree().change_scene_to_file("res://scenes/ui/lose_screen.tscn")
	
@rpc("any_peer","call_local","reliable")
func win_screen()-> void:
	get_tree().change_scene_to_file("res://scenes/ui/win_screen.tscn")

func _ready() -> void:
	#generate_requests()
	Reset_Timer()
	for i in Game.players.size():
		var player_data = Game.players[i]
		var player_inst = player_scene.instantiate()
		players.add_child(player_inst)
		player_inst.setup(player_data)
		player_inst.global_position = markers.get_child(i).global_position

func _on_timer_timeout() -> void:
	if seconds == 0 and minutes > 0:
		minutes -= 1
		seconds = 60
	elif seconds == 0 and minutes == 0:
		GameFunctions.current_state = GameFunctions.GameState.DEFEAT
		lose_screen()
		return
	seconds -=1
	time.text = str(minutes) + ":" + str(seconds)

func Reset_Timer():
	seconds = Dseconds
	minutes = Dminutes

'''
func generate_requests():	
	if is_multiplayer_authority():
		print("Es autoridad, llamando al servidor para generar número")
		rpc_id(0, "_server_random_number")
	else:
		print("No es autoridad, no puede generar número")

@rpc("authority")		
func _server_random_number():
	random_number = rng.randi_range(1, 20)
	print("Server ha generado random number", random_number)
	rpc("_sync_random_number", random_number)
	
@rpc("any_peer")
func _sync_random_number(new_random_number):
	random_number = new_random_number
	print("Número sincronizado en el cliente: ", random_number)
'''	
