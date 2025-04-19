extends Node
class_name Stats


@export_range(1, 100) var intellect: int = 50
@export_range(1, 100) var strength: int = 50
@export_range(1, 100) var speed: int = 50

func get_attack_power() -> int:
	@warning_ignore("integer_division")
	return strength / 15

func get_attack_speed() -> float:
	return 20.0 / speed

func get_move_speed() -> float: 
	return maxf(speed * 6, 250.0)
