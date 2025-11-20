extends ItemContainer

enum EquipmentType{
	OUTFIT,
	WEAPON,
}

@onready var slot: ItemSlot = get_child(0)
@export var equip_type: EquipmentType

func _ready() -> void:
	await owner.ready
	slot.item = owner.outfit

func _on_outfit_slot_item_changed(index: int, new_item: Item) -> void:
	if index != equip_type:
		return
	match equip_type:
		EquipmentType.OUTFIT:
			slot.item = new_item
