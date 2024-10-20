extends Control

@onready var panel1_label = $NinePatchRect/GridContainer/Contador/Label

func _ready() -> void:
	#connect("delivery_updated", update_contador)
	panel1_label.text = str(GameFunctions.n_delivery_carrots)
	
func update_contador():
	panel1_label.text = str(GameFunctions.n_delivery_carrots)
