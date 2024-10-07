extends InvItem
class_name SeedPack

@export var seed_type: int = 1 # El tipo de semilla. 1 carrot
var seed_pack_sprite: AnimatedSprite2D
var selected = false

func _init():
	nam = "Seed Pack"
	#seed_pack_sprite = preload("res://path_to_seedpack_texture.png")
	max_items_per_slot = 1  # Solo un pack de semillas por slot, por ejemplo
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if seed_pack_sprite:
		seed_pack_sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
