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
var player: Player

func _ready() -> void:
	pass

func select_item(index: int) -> void:
	player.inventory.selected_item = index
