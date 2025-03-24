@tool
extends Area2D

const HOLE_DOWN = preload("res://Sprites/World/Hole_down.png")
const HOLE_UP = preload("res://Sprites/World/Hole_up.png")

@onready var _visual = $Visual

@export var go_down: bool:
	set(new_layer):
		go_down = new_layer
		if not is_node_ready():
			await ready
		if go_down:
			_visual.texture = HOLE_DOWN
			collision_layer = 1 << 1
		else:
			_visual.texture = HOLE_UP
			collision_layer = 1 << 0

@export_range(1, 100)
var progress := 1:
	set(new_progress):
		progress = new_progress
		if not is_node_ready():
			await ready
		_visual.frame = roundi(4 - (float(progress) / 100) * 4)

func interact(_entity: Entity) -> void:
	if progress < 100:
		return
	WorldLayerManager.switch_layer(0 if go_down else 1 , global_position)
