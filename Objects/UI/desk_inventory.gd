extends Panel

var current_desk: Desk
var item_slots: Array[DeskItemSlot]

func _ready() -> void:
	var grid = $GridContainer
	for child in grid.get_children():
		if child is not DeskItemSlot:
			continue
		item_slots.append(child)
		child.item_taken.connect(_on_item_taken)

func _on_visibility_changed() -> void:
	if not visible or not current_desk:
		visible = false
		return
	var items = current_desk.items
	for item_index in items.size():
		item_slots[item_index].item = items[item_index]

func _on_item_taken(index: int) -> void:
	current_desk.remove_item(index)
	
func _on_inventory_changed(index: int, item: Item) -> void:
	item_slots[index].item = item

func _on_player_manager_desk_opened(desk: Desk) -> void:
	if current_desk:
		current_desk.inventory_changed.disconnect(_on_inventory_changed)
	current_desk = desk
	current_desk.inventory_changed.connect(_on_inventory_changed)
