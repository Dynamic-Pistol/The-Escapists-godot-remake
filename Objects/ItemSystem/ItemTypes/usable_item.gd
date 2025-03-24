extends Item
class_name UsableItem

signal item_used(new_durability: int)

@export var decay: int
@export var durability := 100:
	set(new_val):
		durability = new_val
		item_used.emit(durability)
