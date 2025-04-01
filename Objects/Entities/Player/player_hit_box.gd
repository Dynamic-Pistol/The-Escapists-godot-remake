extends HitBox
class_name PlayerHitBox

func _input(event: InputEvent) -> void:
	if PlayerManager.player_mode != PlayerManager.PlayerMode.ATTACK:
		return
	if event.is_action_pressed(&"Punch") and can_attack():
		var enemies = get_overlapping_areas().filter(filter_enemies)
		if not enemies.is_empty():
			enemies.sort_custom(func(a, b): return a == target and b != target)
			var enemy: HurtBox = enemies[0]
			attack(enemy)
		else:
			attack(null)
