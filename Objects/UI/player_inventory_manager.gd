extends VBoxContainer

var slots: Array[PlayerItemSlot]
@export
var button_group: ButtonGroup

func _ready() -> void:
	button_group.pressed.connect(select_item)
	for child in get_children():
		if child is PlayerItemSlot:
			slots.append(child)
	await PlayerManager.ready
	PlayerManager.inventory_changed.connect(_on_inventory_change)

func _on_inventory_change(index: int, item: Item) -> void:
	slots[index].item = item

func select_item(btn: BaseButton) -> void:
	var idx = btn.get_index()
	if button_group.get_pressed_button() == null:
		idx = -1
	PlayerManager.selected_item = idx
