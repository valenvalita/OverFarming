extends StaticBody2D
var selected = false
var seed_type = 1 #carrot
@onready var seed_pack_sprite: AnimatedSprite2D = $seed_pack_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seed_pack_sprite.play("default")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		GameFunctions.plant_selected = seed_type
		selected = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
			
