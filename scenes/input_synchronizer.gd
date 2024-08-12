class_name  InputSynchronizer
extends MultiplayerSynchronizer


@export var move_input := 0
@export var jump := false


func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		move_input = Input.get_axis("move_left", "move_right")
		if Input.is_action_just_pressed("jump"):
			jump_broadcast.rpc()


@rpc("call_local")
func jump_broadcast() -> void:
	jump = true
