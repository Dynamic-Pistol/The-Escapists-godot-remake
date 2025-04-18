extends Label
class_name DialogueBox

@export var health: Health

func _on_timer_timeout() -> void:
	if not health.is_alive() or visible:
		return
	$BanterTimer.wait_time = randf_range(8, 25)
	text = DialogueManager.get_basic()
	visible = true
	await get_tree().create_timer(len(text) / 3.25).timeout
	visible = false

func complimented() -> void:
	$BanterTimer.wait_time = randf_range(8, 25)
	text = DialogueManager.get_compliment()
	visible = true
	await get_tree().create_timer(len(text) / 2.0).timeout
	visible = false
