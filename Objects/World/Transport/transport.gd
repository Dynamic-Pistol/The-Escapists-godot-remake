extends Area2D

@export
var target_layer := WorldLayer.WorldLayerType.GROUND
@export
var go_down: bool
@export
var down_texture: Texture2D
@export
var up_texture: Texture2D

func _ready() -> void:
	if go_down:
		$Visual.texture = down_texture
		collision_layer = 1 << (target_layer as int + 1)
	else:
		$Visual.texture = up_texture
		collision_layer = 1 << (target_layer as int - 1)

func interact(_entity: Entity) -> void:
	WorldLayerManager.switch_layer(target_layer as int , global_position)
