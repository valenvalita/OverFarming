extends CharacterBody2D

var speed = 300
var acceleration = 1000

var player
@onready var label: Label = $Label
@onready var input_synchronizer: InputSynchronizer = $InputSynchronizer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			test.rpc()


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	var move_input = input_synchronizer.move_input
	var direction = (Vector2(move_input.x, move_input.y)).normalized()

	if direction:
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false 
		animated_sprite_2d.play("walk")
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		animated_sprite_2d.play("idle")
	
	move_and_slide()

func setup(player_data: Statics.PlayerData) -> void:
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	label.text = player_data.name
	player = player_data


@rpc("authority", "call_local", "unreliable")
func test():
	Debug.log("test %s" % player.name)


@rpc
func send_position(pos: Vector2, vel: Vector2) -> void:
	position = lerp(position, pos, 0.5)
	velocity = lerp(velocity, vel, 0.5)
