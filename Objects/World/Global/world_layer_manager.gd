extends Node2D
class_name WorldLayerManager

static var layers: Array[WorldLayer] = [null, null, null, null]
static var current_layer: WorldLayer

const LAYERS_2_GROUP: Array[StringName] = [
	&"underground",
	&"ground",
	&"vents",
	&"roof"
]

@onready var player: Player = get_tree().get_first_node_in_group(&"player")

static func both_on_same_layer(node1: Node, node2: Node) -> bool:
	var is_in_same_group:bool = false
	for layer in LAYERS_2_GROUP:
		if node1.is_in_group(layer) and node2.is_in_group(layer):
			is_in_same_group = true
			break
	return is_in_same_group

func _ready() -> void:
	for layer in layers:
		if layer == current_layer or not layer:
			continue
		layer.hide()
		layer.collision_enabled = false
	await get_tree().process_frame
	current_layer = layers[1]
	switch_layer(1, player.global_position)

func switch_layer(layer_idx: int, target_pos: Vector2) -> void:
	for layer in layers:
		layer.collision_enabled = false
		layer.hide()
	for layer in layers.slice(0, layer_idx):
		layer.show()
	
	current_layer = layers[layer_idx]
	current_layer.show()
	current_layer.collision_enabled = true
	player.reparent(current_layer)
	player.global_position = target_pos
