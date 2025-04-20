extends Node

var layers: Array[WorldLayer]
var current_layer: WorldLayer

const LAYERS_2_GROUP: Array[StringName] = [
	&"underground",
	&"ground",
	&"vents",
	&"roof"
]

func both_on_same_layer(node1: Node, node2: Node) -> bool:
	var is_in_same_group:bool = false
	for layer in LAYERS_2_GROUP:
		if node1.is_in_group(layer) and node2.is_in_group(layer):
			is_in_same_group = true
			break
	return is_in_same_group

func _ready() -> void:
	layers.resize(4)
	await get_tree().process_frame
	current_layer = layers[1]
	for layer in layers:
		if layer == current_layer or not layer:
			continue
		layer.hide()
		layer.collision_enabled = false

func switch_layer(layer_idx: int, target_pos: Vector2) -> void:
	if current_layer.layer != WorldLayer.WorldLayerType.GROUND or layer_idx == 0:
		current_layer.hide()
	current_layer.collision_enabled = false
	current_layer = layers[layer_idx]
	current_layer.show()
	current_layer.collision_enabled = true
	var player:Player = PlayerManager.player
	player.reparent(current_layer)
	player.global_position = target_pos
