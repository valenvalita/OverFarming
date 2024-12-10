extends Resource

class_name Inv

signal update
@export var slots: Array[InvSlot]
var max_items_per_slot_dft = 10
var actual_items = 0
var actual_index = 0


func _ready() -> void:
	pass

func insert(item: InvItem):
	var max_items_per_slot = item.max_items_per_slot if item.max_items_per_slot > 0 else max_items_per_slot_dft
	var itemslots = slots.filter(func(slot): return slot.item.nam==item.nam)
	if !itemslots.is_empty():
		if itemslots[0].amount < max_items_per_slot:
			itemslots[0].amount += 1
		else:
			print("Ya has alcanzado el máximo de almacenamiento")
	else:
		actual_items += 1
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			if emptyslots[0].amount < max_items_per_slot:
				emptyslots[0].item = item
				emptyslots[0].amount = 1
			else:
				print("Ya has alcanzado el máximo de almacenamiento")
	update.emit()

func remove_item(item: InvItem) -> int:
	var itemslots = slots.filter(func(slot): return slot.item.nam == item.nam)
	if !itemslots.is_empty():
		#actual_items -= 1
		var quantity = itemslots[0].amount  # Obtener la cantidad del ítem
		itemslots[0].item = null  # Eliminar el ítem del inventario
		itemslots[0].amount = 0   # Restablecer la cantidad a 0
		update.emit()  # Emitir la señal de actualización
		return quantity  # Devolver la cantidad eliminada
	else:
		print("El ítem no se encontró en el inventario")
		return 0  # Devolver 0 si no se encontró el ítem

func remove_item_ctn(item: InvItem, cnt: int) -> void:
	var itemslots = slots.filter(func(slot): return slot.item.nam == item.nam)
	if !itemslots.is_empty():
		var quantity = itemslots[0].amount  # Obtener la cantidad del ítem
		var new_quantity = max(quantity - cnt, 0)
		if new_quantity==0:	
			actual_items -= 1
			itemslots[0].item = null  # Eliminar el ítem del inventario
			itemslots[0].amount = 0   # Restablecer la cantidad a 0
		else:
			itemslots[0].amount = new_quantity
		update.emit()  # Emitir la señal de actualización
		
func has_seed(index : int) -> bool:
	print(index)
	if slots[index].item and slots[index].item.type=="seed":
		return true
	return false
		
func get_seed(index : int):
	if slots[index].item and slots[index].item.type=="seed":
		var seed_item = slots[index].item
		return seed_item
	return null
	
func check_inv(num : int):
	for slot in slots:
		if  num == 0:
			if slot.item and slot.item.nam == "carrot":
				return slot.item
		elif num == 1:
			if slot.item and slot.item.nam == "beetroot":
				return slot.item
		elif num == 2:
			if slot.item and slot.item.nam == "potato":
				return slot.item
		elif num == 3:
			if slot.item and slot.item.nam == "pumpkin":
				return slot.item
	return null
