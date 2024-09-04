extends CharacterBody2D
var speed = 300
var acceleration = 1000

var player
@onready var label: Label = $Label
@onready var input_synchronizer: InputSynchronizer = $InputSynchronizer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D
@onready var sprite_position: Marker2D = $SpritePosition

var water = preload("res://scenes/watering.tscn")
var dig = preload("res://scenes/digging.tscn")

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			test.rpc()
		if event.is_action_pressed("watering"):
			watering_action()
			rpc("watering_action")
		if event.is_action_pressed("digging"):
			digging_action()
			rpc("digging_action")



@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var move_input = input_synchronizer.move_input
	var direction = (Vector2(move_input.x, move_input.y)).normalized()

	if direction:
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
			marker.position.x = -abs(marker.position.x)
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
			marker.position.x = abs(marker.position.x)
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
	
@rpc("reliable")
func watering_action() -> void:
	var water_instance = water.instantiate()
	add_child(water_instance)
	water_instance.watering(self, animated_sprite_2d , marker)

@rpc("reliable")
func digging_action() -> void:
	animated_sprite_2d.visible = false
	var dig_instance = dig.instantiate()
	add_child(dig_instance)
	dig_instance.digging(self, animated_sprite_2d, sprite_position)
