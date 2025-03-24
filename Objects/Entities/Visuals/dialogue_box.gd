extends Label

@export var health: Health

func _on_timer_timeout() -> void:
	if not health.is_alive():
		return
	$BanterTimer.wait_time = randf_range(8, 25)
	text = DialogueManager.get_basic()
	visible = true
	await get_tree().create_timer(len($Label.text) / 2.0).timeout
	visible = false
