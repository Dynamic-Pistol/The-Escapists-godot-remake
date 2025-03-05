extends RayCast2D
class_name Interactor

@export
var entity: Entity

func interact() -> void:
	if is_colliding():
		var col := get_collider()
		if col.has_method("interact"):
			col.interact(entity)

func pickup() -> void:
	if is_colliding():
		var col := get_collider()
		if col.has_method("pick_up"):
			col.pick_up(entity)
	
