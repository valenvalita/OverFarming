extends Control
@onready var inv: Inv = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

@onready var selector1 = $NinePatchRect/GridContainer/inv_UI_slot1/Selector
@onready var selector2 = $NinePatchRect/GridContainer/inv_UI_slot2/Selector
@onready var selector3 = $NinePatchRect/GridContainer/inv_UI_slot3/Selector
@onready var selector4 = $NinePatchRect/GridContainer/inv_UI_slot4/Selector
@onready var selector5 = $NinePatchRect/GridContainer/inv_UI_slot5/Selector
@onready var selector6 = $NinePatchRect/GridContainer/inv_UI_slot6/Selector
@onready var selector7 = $NinePatchRect/GridContainer/inv_UI_slot7/Selector
@onready var selector8 = $NinePatchRect/GridContainer/inv_UI_slot8/Selector

@onready var selectores = [
	selector1,
	selector2,
	selector3,
	selector4,
	selector5,
	selector6,
	selector7,
	selector8
]

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	selector2.visible = false
	selector3.visible = false
	selector4.visible = false
	selector5.visible = false
	selector6.visible = false
	selector7.visible = false
	selector8.visible = false
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func inv_selector(index : int) -> void:
	for i in range(selectores.size()):
		selectores[i].visible = false
	selectores[index].visible = true
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory") and is_multiplayer_authority():
		if is_open:
			close()
		else:
			open()
