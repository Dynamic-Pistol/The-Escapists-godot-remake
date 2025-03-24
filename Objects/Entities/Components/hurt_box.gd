extends Area2D
class_name HurtBox

@export var health: Health
@onready var entity: InteractableEntity = get_parent()

func damage(amount: int) -> void:
	if health:
		health.damage(amount)
