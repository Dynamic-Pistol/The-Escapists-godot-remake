extends InteractableEntity

@onready var own_layer = WorldLayerManager.layers[WorldLayer.WorldLayerType.GROUND]
var path: PackedVector2Array
var way_points: Array[Node2D]
var current_point: int

@export var nav_agent: NavigationAgent2D
var map_rid: RID


func _ready() -> void:
	var way_points_nodes := get_tree().get_nodes_in_group(&"waypoint")
	way_points.assign(way_points_nodes)
	#super()
	#map_rid = nav_agent.get_navigation_map()
	#set_physics_process(false)
	#call_deferred(&"setup_nav")
#
#func setup_nav() -> void:
	#await NavigationServer2D.map_changed
	#set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if not health.is_alive():
		return
	move()

func move() -> void:
	if not own_layer:
		own_layer = WorldLayerManager.layers[WorldLayer.WorldLayerType.GROUND]
		
	#if nav_agent.is_navigation_finished():
		#nav_agent.target_position = NavigationServer2D.map_get_random_point(map_rid, nav_agent.navigation_layers, false)
	#var dir = global_position.direction_to(nav_agent.get_next_path_position())
	if path.is_empty():
		path = own_layer.get_desintation(global_position, way_points.pick_random().global_position)
		current_point = 0
		
	if global_position.distance_to(path[current_point]) <= 5:
		current_point += 1
		if current_point >= path.size():
			path = own_layer.get_desintation(global_position, way_points.pick_random().global_position)
			current_point = 0
	
	
	var dir = global_position.direction_to(path[current_point])
	if dir:
		const SPEED = 300.0
		#nav_agent.velocity = velocity
		velocity = dir * SPEED
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir
	
