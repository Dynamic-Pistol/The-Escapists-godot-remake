extends HitBox
class_name NPCHitBox


func _physics_process(_delta: float) -> void:
	if not target or not can_attack():
		return
	if not target.owner.is_alive():
		target = null
		return
	if not filter_enemies(target):
		return
	if overlaps_area(target):
		attack(target)

func _on_knocked_out() -> void:
	target = null

func _on_body_entered(body: Node2D) -> void:
	if body is Player and owner.hates_player():
		target = body.get_node(^"HurtBox")
