extends Area2D

const LADDER_DOWN = preload("res://Sprites/World/ladder_down.png")
const LADDER_UP = preload("res://Sprites/World/ladder_up.png")

@onready var _visual = $Visual

@export_enum("Ground:1", "Vents:2", "Roof:3") var target_layer := 1:
	set(new_layer):
		target_layer = new_layer
		if not is_node_ready():
			await ready
		if own_layer > target_layer:
			_visual.texture = LADDER_DOWN
		else:
			_visual.texture = LADDER_UP

var own_layer: int

func _ready() -> void:
	var world_layer = get_parent() as WorldLayer
	if not world_layer:
		queue_free()
		return
	own_layer = world_layer.layer

func interact(_entity: Entity) -> void:
	owner.switch_layer(target_layer as int , global_position)
