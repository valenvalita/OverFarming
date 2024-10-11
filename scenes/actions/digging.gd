extends Node2D
@onready var player_actual: CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D

var digging_duration = 1.0
var digging_timer = 0.0
var is_digging = false
var action_type = "digging"

func digging(player : CharacterBody2D, animated: AnimatedSprite2D, marker : Marker2D) -> void:
	player.set_process_input(false)
	player.set_physics_process(false)
	position = marker.position
	if player.animated_sprite_2d.flip_h == true:
		scale.x = -2
	elif player.animated_sprite_2d.flip_h == false:
		scale.x = 2
	player_actual = player
	animated_sprite_2d = animated
	$AnimatedSprite2Dbody.play()
	$AnimatedSprite2Dhair.play()
	$AnimatedSprite2Dtool.play()
	digging_timer = 0.0
	is_digging = true

func _process(delta: float) -> void:
	if is_digging:
		digging_timer += delta
		if digging_timer >= digging_duration:
			_on_digging_timeout()

func _on_digging_timeout() -> void:
	is_digging = false
	visible = false
	$AnimatedSprite2Dbody.pause()
	$AnimatedSprite2Dhair.pause()
	$AnimatedSprite2Dtool.pause()
	animated_sprite_2d.visible = true
	player_actual.set_process_input(true)
	player_actual.set_physics_process(true)
	queue_free()
