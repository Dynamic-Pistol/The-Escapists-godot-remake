extends GridContainer

var current_desk: Desk

var slots: Array[ItemSlot]

func _ready() -> void:
	for child in get_children():
		if child is ItemSlot:
			slots.append(child)

func desk_opened(desk: Desk) -> void:
	get_parent().show()
	current_desk = desk
	current_desk.inventory_changed.connect(_on_inventory_changed)
	var items = current_desk.items
	for item_index in slots.size():
		slots[item_index].owning_container = desk
		slots[item_index].item = items[item_index]

func _on_player_desk_closed() -> void:
	if not current_desk:
		return
	current_desk.inventory_changed.disconnect(_on_inventory_changed)
	current_desk = null

func _on_inventory_changed(index: int, item: Item) -> void:
	slots[index].item = item

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		get_parent().hide()
		owner.close_desk()
