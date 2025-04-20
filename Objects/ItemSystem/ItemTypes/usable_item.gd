extends Item
class_name UsableItem

signal item_used(new_durability: int)

@export var decay: int
var durability :int = 100

func degrade() -> void:
	durability -= decay
	item_used.emit(durability)
