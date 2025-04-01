extends Node

var layers: Array[WorldLayer]
var current_layer: WorldLayer

func _ready() -> void:
	layers.resize(4)
	await get_tree().process_frame
	current_layer = layers[1]

func switch_layer(layer_idx: int, target_pos: Vector2) -> void:
	if current_layer.layer != WorldLayer.WorldLayerType.GROUND or layer_idx == 0:
		current_layer.visible = false
	current_layer = layers[layer_idx]
	current_layer.visible = true
	var player:Player = PlayerManager.player
	player.reparent(current_layer)
	player.switch_layer(layer_idx)
	player.global_position = target_pos
