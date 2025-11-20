extends HBoxContainer

@export var button_group: ButtonGroup
var slots: Array[ItemSlot]

func _ready() -> void:
	for child in get_children():
		if child is ItemSlot:
			slots.append(child)
			child.owning_container = owner
	button_group.pressed.connect(select_item)

func _on_inventory_changed(index: int, item: Item) -> void:
	if index > 5:
		return
	slots[index].item = item

func select_item(btn: BaseButton) -> void:
	var idx = btn.get_index()
	if button_group.get_pressed_button() == null:
		idx = -1
	owner.select_item(idx)
