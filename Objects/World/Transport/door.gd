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
			$NavigationObstacle2D.affect_navigation_mesh = false
			$NavigationObstacle2D.carve_navigation_mesh = false
		else:
			$NavigationObstacle2D.affect_navigation_mesh = true
			$NavigationObstacle2D.carve_navigation_mesh = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not _visual.visible:
		return
	if not (body.collision_mask & collision_layer):
		return
	if body is Player and key_type != KeyType.NONE:
		const Routine = TimeManager.Routine
		if key_type == KeyType.CELL:
			if TimeManager.current_routine == Routine.LIGHTS_OUT and not (body.current_keys & key_type):
				return
		elif key_type == KeyType.ENTERANCE:
			if not (TimeManager.hours >= 10 and TimeManager.hours <= 22) and not (body.current_keys & key_type):
				return
		else:
			if not (body.current_keys & key_type):
				return
			
	$DoorCollider.set_deferred(&"disabled", true)
	_visual.visible = false
	$Sound.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if _visual.visible:
		return
	if not (body.collision_mask & collision_layer):
		return
	if $EntityCheck.get_overlapping_bodies().size() > 0:
		return
	$DoorCollider.set_deferred(&"disabled", false)
	_visual.visible = true
	$Sound.play()
