extends GridContainer

var slots: Array[ItemSlot]

func _ready() -> void:
	for child in get_children():
		if child is ItemSlot:
			slots.append(child)
			child.owning_container = owner

func _on_inventory_changed(index: int, item: Item) -> void:
	if index < 6:
		return
	slots[index-6].item = item
