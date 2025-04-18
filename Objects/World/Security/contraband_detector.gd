extends Area2D

@onready var visual: Sprite2D = $Visual

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	if PlayerManager.has_illegals():
		visual.frame = 1
		await get_tree().create_timer(0.65).timeout
		visual.frame = 0
