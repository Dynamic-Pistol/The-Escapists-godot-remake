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
	if not picker.collision_mask & collision_layer:
		return false
	var inventory = picker.inventory
	if inventory.add_item(item):
		queue_free()
		return true
	return false

func is_contraband() -> bool:
	return item.is_contraband
