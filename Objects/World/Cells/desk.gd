extends AnimatableBody2D
class_name Desk

signal inventory_changed(index: int, item: Item)

var items: Array[Item]

func _ready() -> void:
	items.resize(30)

func interact(_interactor: InteractableEntity) -> void:
	PlayerManager.open_desk(self)

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
