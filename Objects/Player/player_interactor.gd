extends Interactor

func _process(_delta: float) -> void:
	var dir = global_position.direction_to(get_global_mouse_position()).normalized()
	const INTERACTION_DIST = 60
	target_position = dir * INTERACTION_DIST

func _input(event: InputEvent) -> void:
	if event.is_action(&"Pickup") and event.is_pressed():
		pickup()
	if event.is_action(&"Interact") and event.is_pressed():
		interact()
