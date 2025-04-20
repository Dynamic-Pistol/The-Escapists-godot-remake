extends Control

@onready var player_info: Panel = $PlayerInfo
@onready var desk_inventory: Panel = $DeskInventory

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Pause"):
		hide()
		if desk_inventory.visible:
			PlayerManager.close_desk()
	if event.is_action_pressed(&"Show Info") and not desk_inventory.visible:
		show_player_info()

func show_player_info() -> void:
	show()
	hide_all_except(player_info)

func show_desk_inventory() -> void:
	show()
	hide_all_except(desk_inventory)

func hide_all_except(control: Control) -> void:
	for child in get_children():
		if child == control:
			control.show()
			continue
		if child is Control:
			child.hide()
