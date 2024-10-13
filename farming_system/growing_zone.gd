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

@export var item: InvItem
@onready var animated_plant: AnimatedSprite2D = $plant
@onready var soil_sprite: AnimatedSprite2D = $soil_sprite
@onready var grow_timer: Timer = $grow_timer
@onready var start_growing_plant: Timer = $start_growing_plant

func _ready() -> void:
	soil_sprite.frame = 0 # Tierra sin nada
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
			var player = area.get_parent().player_actual
			player.collect(item)
			pick_plant()
			
	if not plant_growing:
		if area.is_in_group("Plant") and current_state == SoilState.DUG_SOIL:
			plant_seed()
		else:
			print("No puede plantar aquí en este estado.")
	else:
		print("La planta ya está creciendo aquí.")

###### LÓGICA DE ESTADOS AL PLANTAR ######

## LÓGICA PARA CAVAR TIERRA ##
func dig_soil():
	print("Se cava hoyo")
	if is_multiplayer_authority():
		rpc_id(0, "_server_dig_soil")
	else:
		rpc("_request_dig_soil")

@rpc("any_peer")
func _request_dig_soil():
	if is_multiplayer_authority():
		_server_dig_soil()

@rpc("authority")
func _server_dig_soil():
	current_state = SoilState.DUG_SOIL
	soil_sprite.frame = 1
	rpc("_sync_dig_soil", current_state)

@rpc("any_peer")
func _sync_dig_soil(new_state):
	current_state = new_state
	soil_sprite.frame = 1
	
## LÓGICA PARA PLANTAR SEMILLAS ##
func plant_seed():
	print("Se siembra")
	if is_multiplayer_authority():
		rpc_id(0, "_server_plant_seed")
	else:
		rpc("_request_plant_seed")	
		
@rpc("any_peer")  # Permitir que cualquier cliente llame a esta función
func _request_plant_seed():
	# Esta función es llamada por el cliente y la ejecuta el servidor
	if is_multiplayer_authority():  # Verifica si este nodo es el servidor
		_server_plant_seed()

@rpc("authority")  # Solo el servidor tiene autoridad para ejecutar esta función
func _server_plant_seed():
	# Aquí el servidor maneja la lógica de plantar la semilla
	current_state = SoilState.SEEDED_SOIL
	soil_sprite.frame = 2
	# Envía la actualización de estado a todos los clientes
	rpc("_sync_plant_state", current_state)

@rpc("any_peer")  # Sincroniza el estado con todos los clientes
func _sync_plant_state(new_state):
	# Actualiza el estado en los clientes
	current_state = new_state
	if current_state == SoilState.SEEDED_SOIL:
		soil_sprite.frame = 2
		
## LÓGICA PARA REGAR PLANTAS ##	
func water_soil():
	print("Se riega")
	if is_multiplayer_authority():
		rpc_id(0, "_server_water_soil")
	else:
		rpc("_request_water_soil")

@rpc("any_peer")  
func _request_water_soil():
	if is_multiplayer_authority(): 
		_server_water_soil()

@rpc("authority")  
func _server_water_soil():
	current_state = SoilState.WATERED_SOIL
	soil_sprite.frame = 3
	rpc("_sync_water_soil", current_state)

@rpc("any_peer") 
func _sync_water_soil(new_state):
	current_state = new_state
	soil_sprite.frame = 3

## LÓGICA DE CRECIMIENTO PLANTA ##	
func _on_start_growing_plant_timeout() -> void:
	grow_plant()
		
func grow_plant():
	if is_multiplayer_authority():
		_server_grow_plant()
	else:
		rpc("_request_grow_plant")

@rpc("any_peer")
func _request_grow_plant():
	if is_multiplayer_authority():
		_server_grow_plant()

@rpc("authority")
func _server_grow_plant():
	plant_growing = true
	grow_timer.start()
	animated_plant.play("carrot_growing")
	rpc("_sync_grow_plant", plant_growing)

@rpc("any_peer")
func _sync_grow_plant(is_growing):
	plant_growing = is_growing
	animated_plant.play("carrot_growing")
	grow_timer.start()

func _on_grow_timer_timeout() -> void:
	if is_multiplayer_authority():
		_server_grow_step()
		animated_plant.frame += 1

@rpc("authority")
func _server_grow_step():
	var carrot_plant = animated_plant
	if carrot_plant.frame == 0:
		carrot_plant.frame = 1
	elif carrot_plant.frame == 2:
		carrot_plant.frame = 3
		current_state = SoilState.FULLY_GROWN_PLANT
		plant_grown = true
	else:
		carrot_plant.frame += 1
	rpc("_sync_grow_step", carrot_plant.frame, current_state, plant_grown)

@rpc("any_peer")
func _sync_grow_step(frame, new_state, is_grown):
	animated_plant.frame = frame
	current_state = new_state
	plant_grown = is_grown
	if plant_grown:
		print("La planta ya creció")
		
## LÓGICA PARA RECOGER PLANTAS ##
func pick_plant():
	print("Se recoge planta")
	if is_multiplayer_authority():
		rpc_id(0, "_server_pick_plant")
	else:
		rpc("_request_pick_plant")
		
@rpc("any_peer")  
func _request_pick_plant():
	if is_multiplayer_authority(): 
		_server_pick_plant()

@rpc("authority")
func _server_pick_plant():
	current_state = SoilState.BARE_SOIL
	animated_plant.play("default")
	plant_growing = false
	plant_grown = false
	rpc("_sync_pick_plant", current_state)

@rpc("any_peer")
func _sync_pick_plant(new_state):
	current_state = new_state
	animated_plant.play("default")
	plant_growing = false
	plant_grown = false
	print("Planta recogida")
