extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players
@onready var markers: Node2D = $Markers
@onready var time: Control = $CanvasLayer/Time
var seconds = 0
var minutes = 0
var Dseconds = 30
var Dminutes = 1

func _ready() -> void:
	Reset_Timer()
	for i in Game.players.size():
		var player_data = Game.players[i]
		var player_inst = player_scene.instantiate()
		players.add_child(player_inst)
		player_inst.setup(player_data)
		player_inst.global_position = markers.get_child(i).global_position
		


func _on_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -=1
	time.text = str(minutes) + ":" + str(seconds)

func Reset_Timer():
	seconds = Dseconds
	minutes = Dminutes
