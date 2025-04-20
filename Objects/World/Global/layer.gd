extends TileMapLayer
class_name WorldLayer

enum WorldLayerType{
UNDERGROUND = 0,
GROUND = 1,
VENTS = 2,
ROOF = 3
}

@export var layer: WorldLayerType = WorldLayerType.GROUND

var base_tiles: Dictionary[Vector2i, Vector3i]
var destroyed_tiles: Array[Vector2i]

func _ready() -> void:
	WorldLayerManager.layers[layer as int] = self
	
	if layer != WorldLayerType.GROUND:
		return
	
	for cell in get_used_cells():
		var coords = get_cell_atlas_coords(cell)
		var source = get_cell_source_id(cell)
		base_tiles[cell] = Vector3i(coords.x, coords.y, source)


func get_cell_position(cell_position: Vector2) -> Vector2i:
	return local_to_map(to_local(cell_position))

func tile_is_destroyed(cell_position: Vector2) -> bool:
	var pos := get_cell_position(cell_position)
	return destroyed_tiles.has(pos)

func fix_tile(cell_position: Vector2) -> void:
	var pos := get_cell_position(cell_position)
	var tile = base_tiles[pos]
	set_cell(pos, tile.z, Vector2i(tile.x, tile.y))
	destroyed_tiles.erase(pos)

func destroy_tile(cell_position: Vector2) -> void:
	var pos := get_cell_position(cell_position)
	set_cell(pos, 1, Vector2i(3, 2))
	destroyed_tiles.append(pos)

func _on_child_entered_tree(node: Node) -> void:
	_set_group_for_node(node)

func _set_group_for_node(node: Node) -> void:
	const LAYERS_2_GROUPS = WorldLayerManager.LAYERS_2_GROUP
	for group in LAYERS_2_GROUPS:
		node.remove_from_group(group)
	node.add_to_group(LAYERS_2_GROUPS[layer])
	for child in node.get_children():
		_set_group_for_node(child)
