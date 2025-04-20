extends Node

enum KeyType{
	NONE = 1 << 0,
	CELL = 1 << 1,
	ENTERANCE = 1 << 2,
	UTILITY = 1 << 3,
	WORK = 1 << 4,
	STAFF = 1 << 5,
	GUARD = 1 << 6,
	WARDEN = 1 << 7
}

enum PlayerMode{
	NORMAL = 1 << 0,
	ATTACK = 1 << 1,
	USE_ITEM = 1 << 2,
}

signal player_mode_changed(new_mode: PlayerMode)

@onready var player: Player = get_tree().get_first_node_in_group(&"player")

var player_mode: PlayerMode = PlayerMode.NORMAL:
	set(new_val):
		if player_mode == new_val:
			return
		player_mode = new_val
		player_mode_changed.emit(player_mode)

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	if event.is_action(&"To Attack"):
		player_mode = PlayerMode.ATTACK if player_mode == PlayerMode.NORMAL else PlayerMode.NORMAL


#region Stats

var guard_heat := 0

#endregion

#region Inventory

signal inventory_changed(index: int, item: Item)
signal item_added(item: Item)
signal item_removed(item: Item)
signal desk_opened(desk: Desk)
signal desk_closed

@onready var desk_inventory: Panel = $"Player UI/Panel/ColorRect/DeskInventory"
@onready var panel: ColorRect = $"Player UI/Panel/ColorRect"


var items: Array[Item] = [null, null, null, null, null, null]
var weapon: WeaponItem
var outfit: OutfitItem

var selected_item: int = -1:
	set(new_value):
		selected_item = new_value
		if selected_item == -1:
			player_mode = PlayerMode.NORMAL
		else:
			player_mode = PlayerMode.USE_ITEM

func add_item(item: Item) -> bool:
	for i in items.size():
		if items[i] == null:
			items[i] = item.duplicate(true)
			inventory_changed.emit(i, items[i])
			item_added.emit(items[i])
			if item is UsableItem:
				items[i].item_used.connect(_durability_changed.bind(i))
				if item is KeyItem:
					player.current_keys |= item.key_type
			return true
	return false

func remove_item(index: int) -> void:
	var item = items.pop_at(index)
	items.insert(index, null)
	if selected_item == index:
		selected_item = -1
	if item is UsableItem:
		item.item_used.disconnect(_durability_changed.bind(index))
		if item is KeyItem:
			player.current_keys &= ~item.key_type
	inventory_changed.emit(index, null)
	item_removed.emit(item)

func drop_item(index: int) -> void:
	var item = items.pop_at(index)
	items.insert(index, null)
	if item is KeyItem:
		player.current_keys &= ~item.key_type
	inventory_changed.emit(index, null)
	item_removed.emit(item)
	const ITEM_DROP = preload("res://Objects/ItemSystem/item_drop.tscn")
	var item_drop = ITEM_DROP.instantiate()
	item_drop.collision_layer = player.collision_mask & ~(1 << 4)
	item_drop.item = item
	WorldLayerManager.current_layer.add_child(item_drop)
	item_drop.global_position = player.global_position

func remove_illegals() -> void:
	for i in items.size():
		if items[i].is_contraband:
			remove_item(i)

func has_illegals() -> bool:
	return items.any(func(i: Item): return i and i.is_contraband)

func select_item(index: int) -> void:
	selected_item = index

func get_selected_item() -> Item:
	return items[selected_item]

func has_item_at(index: int) -> bool:
	return items[index] != null

func open_desk(desk: Desk) -> void:
	desk_opened.emit(desk)
	panel.show_desk_inventory()

func close_desk() -> void:
	desk_closed.emit()

func _durability_changed(new_durability: int, item_idx: int) -> void:
	if new_durability <= 0:
		remove_item(item_idx)
#endregion
