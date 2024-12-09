extends Control

@onready var panel1_label = $NinePatchRect/GridContainer/Contador/Label
@onready var panel2_label = $NinePatchRect/GridContainer/Contador2/Label

func _ready() -> void:
	GameFunctions.delivery_updated.connect(update_contador)
	GameFunctions.delivery_updated2.connect(update_contador2)
	panel1_label.text = str(GameFunctions.n_delivery_carrots)
	panel2_label.text = str(GameFunctions.n_delivery_carrots2)
	
func update_contador(n_delivery_carrots):
	print("HOLA")
	panel1_label.text = str(n_delivery_carrots)

func update_contador2(n_delivery_carrots2):
	print("HOLA2")
	panel2_label.text = str(n_delivery_carrots2)
