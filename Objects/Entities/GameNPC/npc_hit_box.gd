extends HitBox
class_name NPCHitBox

func _physics_process(_delta: float) -> void:
	if not target or not can_attack():
		return
	if not filter_enemies(target):
		return
	if overlaps_area(target):
		if not target.health.is_alive():
			target = null
		attack(target)	
