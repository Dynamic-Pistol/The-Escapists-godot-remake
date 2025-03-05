extends TextureButton
class_name PlayerItemSlot

var item: Item:
	set(new_value):
		item = new_value
		if new_value:
			$ItemVisual.texture = new_value.texture
			disabled = false
			print(item.name)
			tooltip_text = item.name
			print(tooltip_text)
		else:
			$ItemVisual.texture = null
			disabled = true
			tooltip_text = ""

func _make_custom_tooltip(for_text: String) -> Object:
	var tool_tip := preload("res://Objects/UI/Tooltips/item_slot_tooltip.tscn").instantiate()
	tool_tip.text = for_text
	print(for_text)
	tool_tip.label_settings.font_color = Color.RED if item and item.is_contraband else Color.GREEN
	return tool_tip
