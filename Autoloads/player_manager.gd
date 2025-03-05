extends Node


var player: Player

func _ready() -> void:
	pass

func select_item(index: int) -> void:
	player.inventory.selected_item = index
