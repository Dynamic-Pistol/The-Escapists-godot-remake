@icon("res://addons/plenticons/icons/64x-hidpi/creatures/heart-gray.png")
extends Node
class_name Health

signal health_changed(new_health: int)
signal damaged(new_health: int)
signal knocked_out

@export var stats: Stats
@onready var health := get_max_health():
	set(new_val):
		health = new_val
		health_changed.emit(health)

func is_alive() -> bool:
	return health > 0

func get_max_health() -> int:
	return maxi(floori(stats.strength / 2.0), 5)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_O and owner.name == &"Player":
		health = get_max_health()

func revive() -> void:
	health = get_max_health()

func damage(amount: int) -> void:
	health -= amount
	damaged.emit(health)
	if health <= 0:
		knocked_out.emit()
