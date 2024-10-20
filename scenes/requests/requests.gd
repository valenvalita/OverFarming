extends Control

@onready var panel1_label = $NinePatchRect/GridContainer/Contador/Label

func _ready() -> void:
	GameFunctions.delivery_updated.connect(update_contador)
	panel1_label.text = str(GameFunctions.n_delivery_carrots)
	
func update_contador(n_delivery_carrots):
	print("HOLA")
	panel1_label.text = str(n_delivery_carrots)
	
