extends Node
class_name Health

signal damaged(new_health: int)
signal knocked_out

@export var stats: Stats
@onready var health := get_max_health()

func is_alive() -> bool:
	return health > 0

func get_max_health() -> int:
	return floori(stats.strength / 2.0)

func damage(amount: int) -> void:
	health -= amount
	damaged.emit(health)
	if health <= 0:
		knocked_out.emit()
