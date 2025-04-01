@tool
extends StaticBody2D

const KeyType = PlayerManager.KeyType

@onready var _visual: Sprite2D = $Visual

@export var key_type: KeyType = KeyType.NONE:
	set(new_val):
		if not is_node_ready():
			await ready
		key_type = new_val
		_visual.frame = int(log(key_type) / log(2))
		if key_type == 1:
			$NavigationObstacle2D.avoidance_layers &= ~(1 << 1)
		else:
			$NavigationObstacle2D.avoidance_layers |= 1 << 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not _visual.visible:
		return
	if body is not Entity or body.collision_mask != collision_layer:
		return
	if body is Player and not (body.current_keys & key_type):
		return
	$DoorCollider.set_deferred(&"disabled", true)
	_visual.visible = false
	$Sound.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if _visual.visible:
		return
	if body is not Entity or body.collision_mask != collision_layer:
		return
	if $EntityCheck.get_overlapping_bodies().size() > 0:
		return
	$DoorCollider.set_deferred(&"disabled", false)
	_visual.visible = true
	$Sound.play()
