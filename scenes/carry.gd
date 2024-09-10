extends Node2D
@onready var player_actual: CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D

func carry(player : CharacterBody2D, animated: AnimatedSprite2D, marker : Marker2D) -> void:
	position = marker.position
	if player.animated_sprite_2d.flip_h == true:
		scale.x = -2
	elif player.animated_sprite_2d.flip_h == false:
		scale.x = 2
	player_actual = player
	animated_sprite_2d = animated
	$bodyCarry.play()
	$hairCarry.play()
	$toolCarry.play()

func stop_carry() -> void:
	visible = false
	$bodyCarry.pause()
	$hairCarry.pause()
	$toolCarry.pause()
	animated_sprite_2d.visible = true
