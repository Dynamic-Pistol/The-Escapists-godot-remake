extends VBoxContainer

var slots: Array[PlayerItemSlot]
@export
var button_group: ButtonGroup
var current_desk: Desk

func _ready() -> void:
	button_group.pressed.connect(select_item)
	for child in get_children():
		if child is PlayerItemSlot:
			slots.append(child)
	await PlayerManager.ready
	PlayerManager.inventory_changed.connect(_on_inventory_change)
	PlayerManager.desk_opened.connect(_on_desk_opened)
	PlayerManager.desk_closed.connect(_on_desk_closed)

func _on_inventory_change(index: int, item: Item) -> void:
	slots[index].item = item

func _on_desk_opened(desk: Desk) -> void:
	current_desk = desk
	for slot in slots:
		slot.toggle_mode = false
		slot.pressed.connect(_add_item_to_desk.bind(slot.get_index()))

func _on_desk_closed() -> void:
	current_desk = null
	for slot in slots:
		slot.toggle_mode = true
		slot.pressed.disconnect(_add_item_to_desk.bind(slot.get_index()))

func _add_item_to_desk(index: int) -> void:
	if current_desk.add_item(PlayerManager.items[index]):
		PlayerManager.remove_item(index)

func select_item(btn: BaseButton) -> void:
	var idx = btn.get_index()
	if button_group.get_pressed_button() == null:
		idx = -1
	PlayerManager.selected_item = idx
