extends Control

@onready var desk_inventory: Panel = $"../DeskPanel"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Pause"):
		hide()
		if desk_inventory.visible:
			owner.close_desk()
	if event.is_action_pressed(&"Show Info") and not desk_inventory.visible:
		visible = not visible


func show_desk_inventory(desk: Desk) -> void:
	show()
	hide_all_except(desk_inventory)
	desk_inventory.desk_opened(desk)

func hide_all_except(control: Control) -> void:
	for child in get_children():
		if child == control:
			control.show()
			continue
		if child is Control:
			child.hide()
