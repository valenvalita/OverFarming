extends CharacterBody2D

var speed = 400
var acceleration = 1000

var player
@onready var label: Label = $Label
@onready var input_synchronizer: InputSynchronizer = $InputSynchronizer


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			test.rpc()


func _physics_process(delta: float) -> void:
	var move_input = input_synchronizer.move_input_dir

	var direction = (Vector2(move_input.x, move_input.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

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
