extends Node2D
class_name WorldLayer

enum WorldLayerType{
UNDERGROUND = 0,
GROUND = 1,
VENTS = 2,
ROOF = 3
}

@export
var layer: WorldLayerType = WorldLayerType.GROUND

func _ready() -> void:
	WorldLayerManager.layers[layer as int] = self
