extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players
@onready var markers: Node2D = $Markers
@onready var time: Control = $CanvasLayer/Time
var seconds = 0
var minutes = 0
var Dseconds = 200
var Dminutes = 0

var rng = RandomNumberGenerator.new()

@rpc("any_peer","call_local","reliable")
func lose_screen()-> void:
	get_tree().change_scene_to_file("res://scenes/ui/lose_screen.tscn")
	
@rpc("any_peer","call_local","reliable")
func win_screen()-> void:
	get_tree().change_scene_to_file("res://scenes/ui/win_screen.tscn")

func _ready() -> void:
	generate_requests()
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

func generate_requests():	
	if is_multiplayer_authority():
		GameFunctions.n_delivery_carrots = rng.randi_range(1, 20)
