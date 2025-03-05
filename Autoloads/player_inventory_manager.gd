extends VBoxContainer

var slots: Array[PlayerItemSlot]
@export
var button_group: ButtonGroup

func _ready() -> void:
	button_group.pressed.connect(select_item)
	for child in get_children():
		if child is PlayerItemSlot:
			slots.append(child)
	while PlayerManager.player == null:
		await get_tree().process_frame
	PlayerManager.player.inventory.inventory_changed.connect(on_inventory_change)

func on_inventory_change(index: int, item: Item) -> void:
	slots[index].item = item

func select_item(btn: BaseButton) -> void:
	var idx = btn.get_index()
	if button_group.get_pressed_button() == null:
		idx = -1
	PlayerManager.player.inventory.selected_item = idx
