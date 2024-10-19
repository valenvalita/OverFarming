extends Control
var requests = 0
@onready var panel1_label = $NinePatchRect/GridContainer/Contador/Label


func generate(number : int) -> void:
	panel1_label.text = str(number)
