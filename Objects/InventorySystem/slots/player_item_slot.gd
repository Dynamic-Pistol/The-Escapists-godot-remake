extends TextureButton
class_name PlayerItemSlot

var item: Item:
	set(new_value):
		if item and item is UsableItem:
			item.item_used.disconnect(_durability_changed)
		item = new_value
		if new_value:
			$ItemVisual.texture = new_value.texture
			disabled = false
			if item is UsableItem:
				item.item_used.connect(_durability_changed)
				_durability_changed(item.durability)
			else:
				tooltip_text = item.name
		else:
			$ItemVisual.texture = null
			disabled = true
			tooltip_text = ""

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				button_pressed = not button_pressed
			MOUSE_BUTTON_RIGHT:
				PlayerManager.player.inventory.remove_item(get_index())

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("Selected Item: ", item.name)
	else:
		print("Unselected Item: ", item.name)


func _make_custom_tooltip(for_text: String) -> Object:
	var tool_tip := preload("res://Objects/UI/Tooltips/item_slot_tooltip.tscn").instantiate()
	tool_tip.text = for_text
	print(for_text)
	tool_tip.label_settings.font_color = Color.RED if item and item.is_contraband else Color.GREEN
	return tool_tip

func _durability_changed(new_durability: int) -> void:
	if not item:
		return
	tooltip_text = item.name + "(%d%%)" % new_durability
