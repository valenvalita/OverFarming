extends Node2D
@onready var player_actual: CharacterBody2D

var watering_duration = 1.0
var watering_timer = 0.0
var is_watering = false

func watering(player : CharacterBody2D, animated: AnimatedSprite2D, marker : Marker2D) -> void:
	player.set_process_input(false)
	player.set_physics_process(false)
	animated.play("idle")
	position = marker.position
	if player.animated_sprite_2d.flip_h == true:
		scale.x = -1
	elif player.animated_sprite_2d.flip_h == false:
		scale.x = 1
	player_actual = player
	$ToolsWateringStrip5.play()
	watering_timer = 0.0
	is_watering = true

func _process(delta: float) -> void:
	if is_watering:
		watering_timer += delta
		if watering_timer >= watering_duration:
			_on_watering_timeout()

func _on_watering_timeout() -> void:
	is_watering = false
	visible = false
	$ToolsWateringStrip5.pause()
	player_actual.set_process_input(true)
	player_actual.set_physics_process(true)
