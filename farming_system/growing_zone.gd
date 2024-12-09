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
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ToolEfect"):
		# Se está usando una herramienta
		# Paso 1: Cavar
		if area.get_parent().action_type == "digging" and current_state==SoilState.BARE_SOIL:
			dig_soil()
			
		# Paso 2: Plantar
		elif area.get_parent().action_type == "doing" and current_state==SoilState.DUG_SOIL and not plant_growing:
			var player = area.get_parent().player_actual
			plant_seed(player)
		# Paso 3: Regar
		elif area.get_parent().action_type == "watering" and current_state==SoilState.SEEDED_SOIL:
			water_soil()
			start_growing_plant.start()
			
		# Paso 3: Recolectar	
		elif area.get_parent().action_type == "doing" and current_state==SoilState.FULLY_GROWN_PLANT:
			var player = area.get_parent().player_actual
			player.collect(item)
			pick_plant()
			
###### LÓGICA DE ESTADOS AL PLANTAR ######

## LÓGICA PARA CAVAR TIERRA ##
func dig_soil():
	#Debug.log("Se cava hoyo")
	_server_dig_soil.rpc_id(1)

@rpc("any_peer","call_local","reliable")
func _server_dig_soil():
	_sync_dig_soil.rpc(SoilState.DUG_SOIL) 

@rpc("any_peer","call_local","reliable")
func _sync_dig_soil(new_state):
	current_state = new_state
	soil_sprite.frame = 1
	
## LÓGICA PARA PLANTAR SEMILLAS ##
func plant_seed(player):
	Debug.log("Se intenta sembrar")
	if player_has_seed(player):
		var seed_item = player.get_seed()
		player.remove_item_cnt(seed_item, 1)
		Debug.log("Semilla plantada")
		_server_plant_seed.rpc_id(1)
	else:
		Debug.log("Jugador no tiene semillas")
		
func player_has_seed(player):
	return player.has_seed()		

@rpc("any_peer","call_local","reliable")
func _server_plant_seed():
	_sync_plant_state.rpc(SoilState.SEEDED_SOIL)

@rpc("any_peer","call_local","reliable")
func _sync_plant_state(new_state):
	# Actualiza el estado en los clientes
	current_state = new_state
	soil_sprite.frame = 2
		
## LÓGICA PARA REGAR PLANTAS ##	
func water_soil():
	Debug.log("Se riega")
	_server_water_soil.rpc_id(1)

@rpc("any_peer","call_local","reliable")
func _server_water_soil():
	_sync_water_soil.rpc(SoilState.WATERED_SOIL)

@rpc("any_peer","call_local","reliable")
func _sync_water_soil(new_state):
	current_state = new_state
	soil_sprite.frame = 3

## LÓGICA DE CRECIMIENTO PLANTA ##	
func _on_start_growing_plant_timeout() -> void:
	grow_plant()
		
func grow_plant():
	_server_grow_plant.rpc_id(1)

@rpc("any_peer","call_local","reliable")
func _server_grow_plant():
	plant_growing = true
	grow_timer.start()
	animated_plant.play("carrot_growing")
	_sync_grow_plant.rpc(plant_growing)

@rpc("any_peer","call_local","reliable")
func _sync_grow_plant(is_growing):
	plant_growing = is_growing
	animated_plant.play("carrot_growing")
	grow_timer.start()

func _on_grow_timer_timeout() -> void:
	_server_grow_step.rpc_id(1)
	animated_plant.frame += 1

@rpc("any_peer","call_local","reliable")
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
	_sync_grow_step.rpc(carrot_plant.frame, current_state, plant_grown)

@rpc("any_peer","call_local","reliable")
func _sync_grow_step(frame, new_state, is_grown):
	animated_plant.frame = frame
	current_state = new_state
	plant_grown = is_grown
	if plant_grown:
		Debug.log("La planta ya creció")
		
## LÓGICA PARA RECOGER PLANTAS ##
func pick_plant():
	print("Se recoge planta")
	_server_pick_plant.rpc_id(1)

@rpc("any_peer","call_local","reliable")
func _server_pick_plant():
	current_state = SoilState.BARE_SOIL
	animated_plant.play("default")
	plant_growing = false
	plant_grown = false
	_sync_pick_plant.rpc(current_state)

@rpc("any_peer","call_local","reliable")
func _sync_pick_plant(new_state):
	current_state = new_state
	animated_plant.play("default")
	plant_growing = false
	plant_grown = false
	Debug.log("Planta recogida")
