extends CharacterBody2D
var speed = 300
var acceleration = 1000

var player
@export var inv: Inv
@onready var label: Label = $Label
@onready var input_synchronizer: InputSynchronizer = $InputSynchronizer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Marker2D
@onready var sprite_position: Marker2D = $SpritePosition
@onready var camera2d: Camera2D = $Camera2D

var water = preload("res://scenes/actions/watering.tscn")
var dig = preload("res://scenes/actions/digging.tscn")
var carry = preload("res://scenes/actions/carry.tscn")
var doing = preload("res://scenes/actions/doing.tscn")
var is_carry = false
var carry_instance : Node2D

func _ready() -> void:
	# Solo activa la cámara si este jugador es controlado localmente
	if not is_multiplayer_authority():
		camera2d.make_current()  # Activa la cámara del jugador local

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if is_carry == true:
			if event.is_action_pressed("carry"):
				carry_action()
				rpc("carry_action")
		else:
			if event.is_action_pressed("test"):
				test.rpc()
			if event.is_action_pressed("watering"):
				watering_action()
				rpc("watering_action")
			if event.is_action_pressed("digging"):
				digging_action()
				rpc("digging_action")
			if event.is_action_pressed("carry"):
				carry_action()
				rpc("carry_action")
			if event.is_action_pressed("doing"):
				doing_action()
				rpc("doing_action")



@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var move_input = input_synchronizer.move_input
	var direction = (Vector2(move_input.x, move_input.y)).normalized()

	if direction:
		if direction.x < 0:
			animated_sprite_2d.flip_h = true
			marker.position.x = -abs(marker.position.x)
			if is_carry == true:
				if is_multiplayer_authority():
					carry_move()
					rpc("carry_move")
		elif direction.x > 0:
			animated_sprite_2d.flip_h = false
			marker.position.x = abs(marker.position.x)
			if is_carry == true:
				if is_multiplayer_authority():
					carry_move()
					rpc("carry_move")
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
	
@rpc("reliable")
func doing_action() -> void:
	animated_sprite_2d.visible = false
	var doing_instance = doing.instantiate()
	add_child(doing_instance)
	doing_instance.doing(self, animated_sprite_2d, sprite_position)
	
@rpc("reliable")
func carry_action() -> void:
	if is_carry == true:
		carry_instance.stop_carry()
		carry_instance.queue_free()
		is_carry = false
	else:
		animated_sprite_2d.visible = false
		carry_instance = carry.instantiate()
		add_child(carry_instance)
		carry_instance.carry(self, animated_sprite_2d, sprite_position)
		is_carry = true

@rpc("reliable")
func carry_move() -> void:
	if animated_sprite_2d.flip_h == true:
		carry_instance.scale.x = -2
	elif animated_sprite_2d.flip_h == false:
		carry_instance.scale.x = 2

func collect(item):
	inv.insert(item)
