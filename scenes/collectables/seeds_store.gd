extends Node2D

var state = "no seed"
var player_in_area = false

var seed = preload("res://scenes/collectables/seed_collectable.tscn")

@export var item: InvItem
var player = null 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("pick_item"):
			pick_seed()

func _on_pickable_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		player = body

func _on_pickable_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false

func pick_seed():
	player.collect(item)
