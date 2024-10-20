extends Resource

class_name Inv

signal update
@export var slots: Array[InvSlot]
var max_items_per_slot_dft = 10

func insert(item: InvItem):
	var max_items_per_slot = item.max_items_per_slot if item.max_items_per_slot > 0 else max_items_per_slot_dft
	var itemslots = slots.filter(func(slot): return slot.item==item)
	if !itemslots.is_empty():
		if itemslots[0].amount < max_items_per_slot:
			itemslots[0].amount += 1
		else:
			print("Ya has alcanzado el máximo de almacenamiento")
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			if emptyslots[0].amount < max_items_per_slot:
				emptyslots[0].item = item
				emptyslots[0].amount = 1
			else:
				print("Ya has alcanzado el máximo de almacenamiento")
	update.emit()

func remove_item(item: InvItem) -> int:
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		var quantity = itemslots[0].amount  # Obtener la cantidad del ítem
		itemslots[0].item = null  # Eliminar el ítem del inventario
		itemslots[0].amount = 0   # Restablecer la cantidad a 0
		update.emit()  # Emitir la señal de actualización
		return quantity  # Devolver la cantidad eliminada
	else:
		print("El ítem no se encontró en el inventario")
		return 0  # Devolver 0 si no se encontró el ítem

func remove_item_ctn(item: InvItem, cnt: int) -> void:
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		var quantity = itemslots[0].amount  # Obtener la cantidad del ítem
		var new_quantity = max(quantity - cnt, 0)
		if new_quantity==0:	
			itemslots[0].item = null  # Eliminar el ítem del inventario
			itemslots[0].amount = 0   # Restablecer la cantidad a 0
		else:
			itemslots[0].amount = new_quantity
		update.emit()  # Emitir la señal de actualización
		
func has_seed() -> bool:
	for slot in slots:
		if slot.item and slot.item.type=="seed":
			return true
	return false
		
func get_seed():
	for slot in slots:
		if slot.item and slot.item.type=="seed":
			var seed_item = slot.item
			return seed_item
	return null
