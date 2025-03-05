extends Inventory


var selected_item: int = -1:
	set(new_value):
		selected_item = new_value
		if selected_item == -1:
			get_parent().cursor_state = Player.CursorState.NORMAL
		else:
			get_parent().cursor_state = Player.CursorState.USE

func _ready() -> void:
	items.resize(6)

func get_selected_item() -> Item:
	return items[selected_item]
