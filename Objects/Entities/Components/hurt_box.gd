extends Area2D
class_name HurtBox

@export var health: Health
@onready var entity: InteractableEntity = get_parent()
var blocking := false

func damage(amount: int) -> void:
	if health and not blocking:
		health.damage(amount)

func block() -> void:
	const BLOCK_FRAMES = 20
	const FRAMES_PER_SECOND = BLOCK_FRAMES / 60.0
	blocking = true
	await get_tree().create_timer(FRAMES_PER_SECOND).timeout
	blocking = false
