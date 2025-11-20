extends HitBox
class_name PlayerHitBox

func _unhandled_input(event: InputEvent) -> void:
	if owner.player_mode != owner.PlayerMode.ATTACK:
		return
	if event.is_action_pressed(&"Main Action") and can_attack():
		var enemies = get_overlapping_areas().filter(filter_enemies)
		if not enemies.is_empty():
			enemies.sort_custom(func(a, b): return a == target and b != target)
			var enemy: HurtBox = enemies[0]
			attack(enemy)
		else:
			attack(null)
