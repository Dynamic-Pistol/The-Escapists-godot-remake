extends Sprite2D


func _on_health_damaged(_new_health: int) -> void:
	frame = randi_range(0, 4)
	visible = true
	for i in 5:
		await get_tree().process_frame
	visible = false
