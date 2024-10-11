extends Node2D
@onready var player_actual: CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D

var doing_duration = 1.0
var doing_timer = 0.0
var is_doing = false
var action_type = "doing"

func doing(player : CharacterBody2D, animated: AnimatedSprite2D, marker : Marker2D) -> void:
	player.set_process_input(false)
	player.set_physics_process(false)
	position = marker.position
	if player.animated_sprite_2d.flip_h == true:
		scale.x = -2
	elif player.animated_sprite_2d.flip_h == false:
		scale.x = 2
	player_actual = player
	animated_sprite_2d = animated
	$bodyDoing.play()
	$hairDoing.play()
	$toolDoing.play()
	doing_timer = 0.0
	is_doing = true

func _process(delta: float) -> void:
	if is_doing:
		doing_timer += delta
		if doing_timer >= doing_duration:
			_on_doing_timeout()

func _on_doing_timeout() -> void:
	is_doing = false
	visible = false
	$bodyDoing.pause()
	$hairDoing.pause()
	$toolDoing.pause()
	animated_sprite_2d.visible = true
	player_actual.set_process_input(true)
	player_actual.set_physics_process(true)
	queue_free()
