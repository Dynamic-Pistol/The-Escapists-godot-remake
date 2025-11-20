extends Area2D
class_name HurtBox

var blocking := false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Secondary Action") and not blocking:
		block()

func damage(amount: int, _attacker: Object = null) -> void:
	if not blocking:
		owner.damage(amount)

func block() -> void:
	const BLOCK_FRAMES = 20
	const FRAMES_PER_SECOND = BLOCK_FRAMES / 60.0
	blocking = true
	await get_tree().create_timer(FRAMES_PER_SECOND).timeout
	blocking = false
