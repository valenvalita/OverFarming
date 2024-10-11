extends StaticBody2D

enum SoilState 
{ 
	BARE_SOIL,         # Tierra sin nada
	DUG_SOIL,          # Tierra con un hoyo (preparada para plantar)
	SEEDED_SOIL,       # Tierra con semilla
	WATERED_SOIL,      # Tierra regada
	FULLY_GROWN_PLANT  # Tierra con planta ya crecida
}
var current_state = SoilState.BARE_SOIL

var plant = GameFunctions.plant_selected
var plant_growing = false
var plant_grown = false
@onready var animated_plant: AnimatedSprite2D = $plant
@onready var soil_sprite: AnimatedSprite2D = $soil_sprite
@onready var grow_timer: Timer = $grow_timer
@onready var start_growing_plant: Timer = $start_growing_plant

func _ready() -> void:
	soil_sprite.frame = 0 # default soil
	animated_plant.play("default")
	
func _physics_process(delta: float) -> void:
	# Actualizar planta seleccionada 
	if not plant_growing:
		plant = GameFunctions.plant_selected

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ToolEfect"):
		# Se está usando una herramienta
		if area.get_parent().action_type == "digging" and current_state==SoilState.BARE_SOIL:
			dig_soil()

		elif area.get_parent().action_type == "watering" and current_state==SoilState.SEEDED_SOIL:
			water_soil()
			start_growing_plant.start()
			
		elif area.get_parent().action_type == "doing" and current_state==SoilState.FULLY_GROWN_PLANT:
			pick_plant()
			
	if not plant_growing:
		if area.is_in_group("Plant") and current_state == SoilState.DUG_SOIL:
			plant_seed()
		else:
			print("No puede plantar aquí en este estado.")
	else:
		print("La planta ya está creciendo aquí.")

func _on_grow_timer_timeout() -> void:
	var carrot_plant = animated_plant
	#Si se ha regado la tierra comienza a crecer
	if carrot_plant.frame == 0:
		carrot_plant.frame = 1
		grow_timer.start()
	elif carrot_plant.frame == 2:
		carrot_plant.frame = 3
		current_state = SoilState.FULLY_GROWN_PLANT  # La planta está completamente crecida
		print("La planta ya creció")
		plant_grown = true
	else:
		carrot_plant.frame += 1

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("hola")
	if Input.is_action_just_pressed("click"):
		print("click")
		if plant_grown:
			print("Planta ya creció")
			if plant == 1:
				GameFunctions.n_of_carrots += 1
				animated_plant.play("default")
				plant_growing = false
				plant_grown = false
				current_state = SoilState.BARE_SOIL
			else:
				pass
		print("number of carrots: "+ str(GameFunctions.n_of_carrots))
		
# Lógica de estados de tierra al plantar
func dig_soil():
	print("Se cava hoyo")
	current_state = SoilState.DUG_SOIL
	soil_sprite.frame = 1
		
func plant_seed():
	print("Se siembra")
	current_state = SoilState.SEEDED_SOIL
	soil_sprite.frame = 2
		
func water_soil():
	print("Se riega")
	current_state = SoilState.WATERED_SOIL
	soil_sprite.frame = 3
		
func grow_plant():
	plant_growing = true
	grow_timer.start()
	animated_plant.play("carrot_growing")
	
func pick_plant():
	if plant == 1:
		GameFunctions.n_of_carrots += 1
		animated_plant.play("default")
		plant_growing = false
		plant_grown = false
		current_state = SoilState.BARE_SOIL

func _on_start_growing_plant_timeout() -> void:
	grow_plant()
