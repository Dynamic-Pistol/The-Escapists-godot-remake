@tool
extends StaticBody2D
class_name Door

enum KeyType{
	NONE = 0,
	CELL = 1 << 0,
	ENTERANCE = 1 << 1,
	UTILITY = 1 << 2,
	WORK = 1 << 3,
	STAFF = 1 << 4,
	GUARD = 1 << 5,
	WARDEN = 1 << 6
}

@onready var _visual: Sprite2D = $Visual

@export var _key_type: KeyType = KeyType.NONE:
	set(new_val):
		if not is_node_ready():
			await ready
		_key_type = new_val
		if _key_type == 0 or _key_type == 1:
			_visual.frame = _key_type
		else:
			_visual.frame = int(log(_key_type) / log(2)) + 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not _visual.visible:
		return
	if not WorldLayerManager.both_on_same_layer(body, self):
		return
	if body is Player and _key_type != KeyType.NONE:
		const Routine = TimeManager.Routine
		if _key_type == KeyType.CELL:
			if TimeManager.current_routine == Routine.LIGHTS_OUT and not (body.current_keys & _key_type):
				return
		elif _key_type == KeyType.ENTERANCE:
			if not (TimeManager.hours >= 10 and TimeManager.hours <= 22) and not (body.current_keys & _key_type):
				return
		else:
			if not (body.current_keys & _key_type):
				return
			
	$DoorCollider.set_deferred(&"disabled", true)
	_visual.visible = false
	$Sound.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if _visual.visible:
		return
	if not WorldLayerManager.both_on_same_layer(body, self):
		return
	if $EntityCheck.get_overlapping_bodies().size() > 0:
		return
	$DoorCollider.set_deferred(&"disabled", false)
	_visual.visible = true
	$Sound.play()
