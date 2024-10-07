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
@onready var grow_timer: Timer = $grow_timer

func _physics_process(delta: float) -> void:
	# Actualizar planta seleccionada 
	if not plant_growing:
		plant = GameFunctions.plant_selected

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not plant_growing:
		if plant == 1 and current_state == SoilState.DUG_SOIL:
			#Se puede plantar
			plant_growing = true
			grow_timer.start()
			animated_plant.play("carrot_growing")
		else:
			print("No puede plantar aquí en este estado.")
	else:
		print("La planta ya está creciendo aquí.")

func _on_grow_timer_timeout() -> void:
	var carrot_plant = animated_plant
	if current_state == SoilState.WATERED_SOIL:
		#Si se ha regado la tierra comienza a crecer
		if carrot_plant.frame == 0:
			carrot_plant.frame = 1
			grow_timer.start()
		elif carrot_plant.frame == 2:
			carrot_plant.frame = 3
			current_state = SoilState.FULLY_GROWN_PLANT  # La planta está completamente crecida
			plant_grown = true
		else:
			carrot_plant.frame += 1
	else:
		print("La planta no puede crecer sin regar la tierra")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
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
	if current_state == SoilState.BARE_SOIL:
		current_state = SoilState.DUG_SOIL
		print("Has cavado un hoyo en la tierra.")
	else:
		print("No puedes cavar en este estado")
		
func plant_seed():
	if current_state == SoilState.DUG_SOIL:
		current_state = SoilState.SEEDED_SOIL
		print("Has plantado una semilla.")
	else:
		print("No puedes plantar una semilla en este estado.")
		
func water_soil():
	if current_state == SoilState.SEEDED_SOIL:
		current_state = SoilState.WATERED_SOIL
	elif current_state == SoilState.WATERED_SOIL or current_state == SoilState.FULLY_GROWN_PLANT:
		print("La tierra ya ha sido regada.")
	else:
		print("No puedes regar la tierra en este estado.")
		
func grow_plant():
	if current_state == SoilState.WATERED_SOIL:
		current_state = SoilState.FULLY_GROWN_PLANT
		print("La planta ya ha crecido completamente.")
	else:
		print("La planta no puede crecer en este estado")
