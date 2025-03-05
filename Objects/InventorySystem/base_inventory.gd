extends Node
class_name Inventory

signal inventory_changed(index: int, item: Item)

var items: Array[Item]
var weapon: WeaponItem
var outfit: OutfitItem

func add_item(item: Item) -> bool:
	for i in items.size():
		if items[i] == null:
			items[i] = item.duplicate(true)
			inventory_changed.emit(i, items[i])
			return true
	return false

func has_key(key_type: KeyItem.KeyType) -> bool:
	if key_type == KeyItem.KeyType.INVALID:
		return false
	var keys: Array[KeyItem]
	keys.assign(items.filter(func(item): return item is KeyItem))
	for key in keys:
		if key.key_type == key_type:
			return true
	return false

func remove_item(index: int) -> void:
	items[index] = null
	inventory_changed.emit(index, null)

func move_item(index: int) -> Item:
	var item = items[index]
	remove_item(index)
	return item

func remove_illegals() -> void:
	for i in items.size():
		if items[i].is_contraband:
			remove_item(i)
