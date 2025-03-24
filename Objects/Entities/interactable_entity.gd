extends Entity
class_name InteractableEntity

@export var anim_tree: AnimationTree
@export var health: Health

func pick_up(player: Player) -> void:
	reparent(player)
	position = Vector2.ZERO
	player.picked_up_item = self
