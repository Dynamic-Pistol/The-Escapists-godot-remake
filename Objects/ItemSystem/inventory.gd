extends Node
class_name Inventory

signal inventory_changed(index: int, item: Item)
signal item_added(index: int,item: Item)
signal item_removed(index: int, item: Item)

@export var capacity: int
var _items: Array[Item]

func _ready() -> void:
	_items.resize(capacity)

func add_item(item: Item) -> bool:
	for i in _items.size():
		if _items[i] == null:
			_items[i] = item.duplicate(true)
			inventory_changed.emit(i, _items[i])
			item_added.emit(i, _items[i])
			return true
	return false

func set_item(item: Item, index: int) -> bool:
	if _items[index] == null:
		_items[index] = item.duplicate(true)
		inventory_changed.emit(index, _items[index])
		item_added.emit(index, _items[index])
		return true
	return false

func remove_item(index: int) -> void:
	var item = _items[index]
	_items[index] = null
	inventory_changed.emit(index, null)
	item_removed.emit(index, item)

func pop_item(index: int) -> Item:
	var item = _items[index]
	_items[index] = null
	inventory_changed.emit(index, null)
	item_removed.emit(index, item)
	return item

func remove_illegals() -> void:
	for i in _items.size():
		if _items[i].is_contraband:
			remove_item(i)

func has_illegals() -> bool:
	return _items.any(func(i: Item): return i and i.is_contraband)

func has_item_at(index: int) -> bool:
	return _items[index] != null
