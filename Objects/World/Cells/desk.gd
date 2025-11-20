extends AnimatableBody2D
class_name Desk

signal inventory_changed(index: int, item: Item)

var items: Array[Item]

func _ready() -> void:
	items.resize(30)
	var file_paths := DirAccess.get_files_at("res://Resources/Items/")
	for i in randi_range(4, 10):
		items[i] = load("res://Resources/Items/" + file_paths[randi_range(0, file_paths.size() - 1)])

func interact(interactor: Entity) -> void:
	interactor.open_desk(self)

func add_item(item: Item) -> bool:
	for i in items.size():
		if items[i] == null:
			items[i] = item.duplicate(true)
			inventory_changed.emit(i, item)
			return true
	return false

func remove_item(index: int) -> void:
	items[index] = null
	inventory_changed.emit(index, null)

func set_item(item: Item, index: int) -> bool:
	if not item:
		remove_item(index)
		return true
	if items[index] == null:
		items[index] = item.duplicate(true)
		inventory_changed.emit(index, items[index])
		return true
	return false

func swap_items(my_item: int, other_item: int, other_container: Variant) -> void:
	var my_temp: Item = items[my_item]
	remove_item(my_item)
	var other_temp: Item = other_container.items[other_item]
	other_container.remove_item(other_item)
	set_item(other_temp, my_item)
	other_container.set_item(my_temp, other_item)
