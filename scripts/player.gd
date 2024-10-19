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
@onready var hotbar: Control = $HotbarInterface/Hotbar

var water = preload("res://scenes/actions/watering.tscn")
var dig = preload("res://scenes/actions/digging.tscn")
var carry = preload("res://scenes/actions/carry.tscn")
var doing = preload("res://scenes/actions/doing.tscn")
var selector = preload("res://scenes/hotbar/selector.tscn")
var is_carry = false
var carry_instance : Node2D
var selector_instance : Node2D
const NUM_HOTBAR_SLOTS = 4
var active_item_slot = 0

func _ready() -> void:
	if not is_multiplayer_authority():
		camera2d.make_current()

func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if is_carry == true:
			if event.is_action_pressed("doing"):
				if active_item_slot == 2:
					carry_action()
					rpc("carry_action")
		else:
			if event.is_action_pressed("test"):
				test.rpc()
			if event.is_action_pressed("doing"):
				if active_item_slot == 0:
					watering_action()
					rpc("watering_action")
				elif active_item_slot == 1:
					digging_action()
					rpc("digging_action")
				elif active_item_slot == 2:
					carry_action()
					rpc("carry_action")
				elif active_item_slot == 3:
					doing_action()
					rpc("doing_action")
			if event.is_action_pressed("Scroll_Down"):
				active_item_scroll_down()
			if event.is_action_pressed("Scroll_Up"):
				active_item_scroll_up()

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
	hotbar.visible = is_multiplayer_authority()

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
	if is_multiplayer_authority():
		print("Se recoge item")
		inv.insert(item)
		
func remove_item(item):
	if is_multiplayer_authority():
		print("Se elimina item")
		var cnt_item = inv.remove_item(item)
		return cnt_item

func active_item_scroll_up() -> void:
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	hotbar.hotbar_selector(active_item_slot)

func active_item_scroll_down() -> void:
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	hotbar.hotbar_selector(active_item_slot)
