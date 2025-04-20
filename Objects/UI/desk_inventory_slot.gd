extends TextureButton
class_name DeskItemSlot

signal item_taken(index: int)

var item: Item:
	set(new_value):
		item = new_value
		if new_value:
			$ItemVisual.texture = new_value.texture
			disabled = false
			if item is UsableItem:
				tooltip_text = item.name + "(%d%%)" % item.durability
			else:
				tooltip_text = item.name
		else:
			$ItemVisual.texture = null
			disabled = true
			if button_pressed:
				button_pressed = false
			tooltip_text = ""

func _pressed() -> void:
	if PlayerManager.add_item(item):
		item_taken.emit(get_index())
		item = null

func _make_custom_tooltip(for_text: String) -> Object:
	var tool_tip := preload("res://Objects/UI/Tooltips/item_slot_tooltip.tscn").instantiate()
	tool_tip.text = for_text
	tool_tip.label_settings.font_color = Color.RED if item and item.is_contraband else Color.GREEN
	return tool_tip
