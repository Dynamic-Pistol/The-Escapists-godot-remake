@tool
extends Area2D

@export
var item:Item:
	set(new_value):
		item = new_value
		if not new_value:
			return
		$"Visual".texture = item.texture
		name = item.name

func pick_up(picker: Entity) -> bool:
	if not WorldLayerManager.both_on_same_layer(picker, self):
		return false
	if PlayerManager.add_item(item):
		queue_free()
		return true
	return false

func is_contraband() -> bool:
	return item.is_contraband
