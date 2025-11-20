extends Inventory

var _selected_item: int = -1:
	set(new_value):
		_selected_item = new_value
		if _selected_item == -1:
			owner.player_mode = 0
		else:
			owner.player_mode = 1

func select_item(index: int) -> void:
	_selected_item = index

func get_selected_item() -> Item:
	return _items[_selected_item]
