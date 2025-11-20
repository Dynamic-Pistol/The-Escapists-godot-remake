extends Sprite2D

const TARGET_1 = preload("res://Sprites/Entities/Target_1.png")
const TARGET_2 = preload("res://Sprites/Entities/Target_2.png")

var target: HurtBox:
	set(new_val):
		target = new_val
		if target:
			visible = true
			$TargetHPBar.max_value = target.owner.get_max_health()
		else:
			visible = false

func _on_visibility_changed() -> void:
	const FRAME_RATE = 15
	const FRAMES_PER_SECOND = FRAME_RATE / 60.0
	while visible:
		texture = TARGET_1
		await get_tree().create_timer(FRAMES_PER_SECOND).timeout
		texture = TARGET_2
		await get_tree().create_timer(FRAMES_PER_SECOND).timeout
		if not target or not target.owner.is_alive():
			target = null

func _process(_delta: float) -> void:
	if target:
		global_position = target.global_position
		$TargetHPBar.value = target.owner.get_health()
