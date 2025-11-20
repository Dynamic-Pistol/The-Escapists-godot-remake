extends Area2D
class_name Hole

@onready var visual = $Visual
var owning_point: HolePoint
var is_down := false

func interact(_entity: Entity) -> void:
	if not can_go_down():
		return
	if is_down:
		owner.switch_layer(0, global_position)
	else:
		owner.switch_layer(1, global_position)

func can_go_down() -> bool:
	return owning_point.progress >= 100
