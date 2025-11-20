extends Control

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	owner.drop_item(data.get_index())
	data.item_visual.show()

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is ItemSlot and data.owning_container == owner

func _process(_delta: float) -> void:
	visible = get_viewport().gui_is_dragging()
