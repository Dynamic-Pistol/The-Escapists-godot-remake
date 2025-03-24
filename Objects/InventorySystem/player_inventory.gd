extends Node
class_name PlayerInventory

signal inventory_changed(index: int, item: Item)
signal item_added(item: Item)
signal item_removed(item: Item)

const CursorState = preload("res://Objects/Entities/Player/player_cursor.gd").CursorState

var selected_item: int = -1:
	set(new_value):
		selected_item = new_value
		if selected_item == -1:
			get_parent().cursor.cursor_state = CursorState.NORMAL
		else:
			get_parent().cursor.cursor_state = CursorState.USE

func _ready() -> void:
	items.resize(6)
	
func _durability_changed(new_durability: int, item_idx: int) -> void:
	if new_durability <= 0:
		remove_item(item_idx)

var items: Array[Item]
var weapon: WeaponItem
var outfit: OutfitItem

func add_item(item: Item) -> bool:
	for i in items.size():
		if items[i] == null:
			items[i] = item.duplicate(true)
			inventory_changed.emit(i, items[i])
			item_added.emit(items[i])
			if item is UsableItem:
				item.item_used.connect(_durability_changed.bind(i))
				if item is KeyItem:
					get_parent().current_keys |= item.key_type
			return true
	return false


func remove_item(index: int) -> void:
	var item = pop_item(index)
	if item is UsableItem:
		item.item_used.disconnect(_durability_changed.bind(index))
		if item is KeyItem:
			get_parent().current_keys &= ~item.key_type
	inventory_changed.emit(index, null)
	item_removed.emit(item)

func pop_item(index: int) -> Item:
	var item = items[index]
	items[index] = null
	return item

func remove_illegals() -> void:
	for i in items.size():
		if items[i].is_contraband:
			remove_item(i)

func get_selected_item() -> Item:
	return items[selected_item]
