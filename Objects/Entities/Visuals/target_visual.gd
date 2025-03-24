extends Sprite2D

const TARGET_1 = preload("res://Sprites/Entities/Target_1.png")
const TARGET_2 = preload("res://Sprites/Entities/Target_2.png")

var target: HurtBox:
	set(new_val):
		target = new_val
		if target:
			visible = true
			$TargetHPBar.max_value = target.health.get_max_health()
		else:
			visible = false

func _on_visibility_changed() -> void:
	while visible:
		texture = TARGET_1
		for i in 15:
			await get_tree().process_frame
		texture = TARGET_2
		for i in 15:
			await get_tree().process_frame
		if not target or not target.health.is_alive():
			target = null

func _process(_delta: float) -> void:
	if target:
		global_position = target.global_position
		$TargetHPBar.value = target.health.health
