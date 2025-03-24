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
var nav_grid: AStarGrid2D = AStarGrid2D.new()

func _ready() -> void:
	WorldLayerManager.layers[layer as int] = self
	
	if layer != WorldLayerType.GROUND:
		return
	
	nav_grid.region = get_used_rect()
	nav_grid.cell_size = Vector2.ONE * 64
	nav_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	nav_grid.update()
	for cell in get_used_cells():
		var coords = get_cell_atlas_coords(cell)
		var source = get_cell_source_id(cell)
		base_tiles[cell] = Vector3i(coords.x, coords.y, source)
		var cell_data = get_cell_tile_data(cell)
		nav_grid.set_point_solid(cell, not cell_data.get_custom_data("nav_enabled"))

func get_desintation(origin_position: Vector2, target_position: Vector2) -> PackedVector2Array:
	var origin_cell = get_cell_position(origin_position)
	var target_cell = get_cell_position(target_position)
	var id_path = nav_grid.get_id_path(origin_cell, target_cell)
	var path: PackedVector2Array
	for point in id_path:
		path.append(map_to_local(point))
	return path

func get_cell_position(cell_position: Vector2) -> Vector2i:
	return local_to_map(to_local(cell_position))

func tile_is_destroyed(cell_position: Vector2) -> bool:
	var pos := get_cell_position(cell_position)
	return destroyed_tiles.has(pos)

func fix_tile(cell_position: Vector2) -> void:
	var pos := get_cell_position(cell_position)
	var tile = base_tiles[pos]
	set_cell(pos, tile.z, Vector2i(tile.x, tile.y))
	nav_grid.set_point_solid(pos)
	destroyed_tiles.erase(pos)

func destroy_tile(cell_position: Vector2) -> void:
	var pos := get_cell_position(cell_position)
	set_cell(pos, 1, Vector2i(3, 2))
	nav_grid.set_point_solid(pos, false)
	destroyed_tiles.append(pos)
