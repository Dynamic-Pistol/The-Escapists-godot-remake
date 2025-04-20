extends Node2D
class_name HolePoint

const LayerType = WorldLayer.WorldLayerType

var up_hole: Hole
var down_hole: Hole

var underground_layer: WorldLayer

func _enter_tree() -> void:
	underground_layer = WorldLayerManager.layers[LayerType.UNDERGROUND]
	
	up_hole = preload("res://Objects/World/Transport/up_hole.tscn").instantiate()
	up_hole.global_position = global_position
	up_hole.owning_point = self
	up_hole.is_down = false
	
	underground_layer.add_child(up_hole)
	
	down_hole = preload("res://Objects/World/Transport/down_hole.tscn").instantiate()
	down_hole.global_position = global_position
	down_hole.owning_point = self
	down_hole.is_down = true
	
	WorldLayerManager.layers[LayerType.GROUND].add_child(down_hole)

var progress := 1:
	set(new_progress):
		progress = new_progress
		if not is_node_ready():
			await ready
		var frame = roundi(4 - (float(progress) / 100) * 4)
		up_hole.visual.frame = frame
		down_hole.visual.frame = frame
		if progress >= 100:
			var cell_pos = underground_layer.to_local(global_position)
			cell_pos = underground_layer.local_to_map(cell_pos)
			underground_layer.set_cell(cell_pos, 2, Vector2i(0, 0))
