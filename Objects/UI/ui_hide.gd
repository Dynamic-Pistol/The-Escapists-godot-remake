extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Show Info"):
		show_player_info()

func show_player_info() -> void:
	visible = not visible
	$PlayerInfo.update()
