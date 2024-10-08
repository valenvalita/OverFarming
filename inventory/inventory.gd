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
