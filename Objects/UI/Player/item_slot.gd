extends TextureButton
class_name ItemSlot

enum SlotType{
	PLAYER_ITEM,
	PLAYER_OUTFIT,
	PLAYER_WEAPON,
	NPC_ITEM,
	NPC_OUTFIT,
	NPC_WEAPON,
	DESK_ITEM,
}

@export var slot_type: SlotType
@onready var item_visual: TextureRect = $ItemVisual

@export var owning_container: Node

var item: Item:
	set(new_value):
		item = new_value
		if new_value:
			item_visual.texture = new_value.texture
			disabled = false
			tooltip_text = item.name
		else:
			item_visual.texture = null
			disabled = true
			if button_pressed:
				button_pressed = false
			tooltip_text = ""

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		return
	var tex_prev = TextureRect.new()
	tex_prev.texture = item.texture
	tex_prev.z_index = 100
	set_drag_preview(tex_prev)
	item_visual.hide()
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	match slot_type:
		SlotType.PLAYER_ITEM, SlotType.DESK_ITEM:
			return data.item is Item
		SlotType.PLAYER_OUTFIT:
			return data.item is OutfitItem
		SlotType.PLAYER_WEAPON:
			return data.item is WeaponItem
		SlotType.PLAYER_ITEM:
			pass
		SlotType.PLAYER_ITEM:
			pass
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	match [slot_type, data.slot_type]:
		[SlotType.DESK_ITEM ,SlotType.DESK_ITEM], [SlotType.PLAYER_ITEM ,SlotType.DESK_ITEM], \
		[SlotType.DESK_ITEM ,SlotType.PLAYER_ITEM], [SlotType.PLAYER_ITEM ,SlotType.PLAYER_ITEM]:
			owning_container.swap_items(get_index(), data.get_index(), data.owning_container)
		[SlotType.PLAYER_OUTFIT, SlotType.PLAYER_ITEM]:
			owning_container.outfit = data.item
			owning_container.remove_item(data.get_index())
		[SlotType.PLAYER_ITEM, SlotType.PLAYER_OUTFIT]:
			owning_container.set_item(data.item, get_index())
			owning_container.outfit = null
		SlotType.PLAYER_WEAPON:
			pass
		SlotType.PLAYER_ITEM:
			pass
		SlotType.PLAYER_ITEM:
			pass
	data.item_visual.show()

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END and not get_viewport().gui_is_drag_successful():
		item_visual.show()

func _make_custom_tooltip(for_text: String) -> Object:
	var tool_tip := preload("res://Objects/UI/Tooltips/item_slot_tooltip.tscn").instantiate()
	tool_tip.text = for_text
	tool_tip.label_settings.font_color = Color.RED if item and item.is_contraband else Color.GREEN
	return tool_tip
