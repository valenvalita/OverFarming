extends Control
const NUM_HOTBAR_SLOTS = 4
var active_item_slot = 0
@onready var slots = [$NinePatchRect/GridContainer/Panel1, $NinePatchRect/GridContainer/Panel2,
$NinePatchRect/GridContainer/Panel3, $NinePatchRect/GridContainer/Panel4]
@onready var selector1: Node2D = $NinePatchRect/GridContainer/Panel1/Selector
@onready var selector2: Node2D = $NinePatchRect/GridContainer/Panel2/Selector
@onready var selector3: Node2D = $NinePatchRect/GridContainer/Panel3/Selector
@onready var selector4: Node2D = $NinePatchRect/GridContainer/Panel4/Selector

@onready var selectores = [
	selector1,
	selector2,
	selector3,
	selector4
]

func _ready() -> void:
	selector2.visible = false
	selector3.visible = false
	selector4.visible = false
	pass
		
	
func hotbar_selector(index : int) -> void:
	for i in range(selectores.size()):
		selectores[i].visible = false
	selectores[index].visible = true
