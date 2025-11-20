extends Node

const WayPointType = preload("res://Objects/World/Global/waypoint.gd").WayPointType
const Routine = TimeManager.Routine

var _waypoints: Array[WayPoint]
var _unused_inmate_waypoints: Array[WayPoint]
var _unused_guard_waypoints: Array[WayPoint]
var _warden_waypoints: Array[WayPoint]

func _ready() -> void:
	TimeManager.routine_changed.connect(_on_routine_changed)
	while true:
		var current_scene = get_tree().current_scene
		if current_scene and current_scene.name == &"Test":
			break
		await get_tree().process_frame
	var points = get_tree().get_nodes_in_group(&"waypoint")
	_waypoints.assign(points)
	_warden_waypoints.assign(_waypoints.filter(func(w: WayPoint): return w.waypoint_type == WayPointType.WARDEN))

func _on_routine_changed() -> void:
	_unused_inmate_waypoints.clear()
	_unused_inmate_waypoints.assign(_waypoints.filter(_filter_inmate_waypoints))
	_unused_guard_waypoints.clear()
	_unused_guard_waypoints.assign(_waypoints.filter(_filter_guard_waypoints))

func get_waypoint(is_guard: bool) -> Vector2:
	var point: WayPoint
	if is_guard:
		_unused_guard_waypoints.shuffle()
		point = _unused_guard_waypoints.pop_front()
	else:
		_unused_inmate_waypoints.shuffle()
		point = _unused_inmate_waypoints.pop_front()
	if not point:
		return Vector2()
	return point.global_position

func get_waypoint_no_consume() -> Vector2:
	var point: WayPoint = _waypoints.filter(_filter_inmate_waypoints).pick_random()
	if not point:
		return Vector2()
	return point.global_position
	
func get_waypoint_warden() -> Vector2:
	var point = _warden_waypoints.pick_random()
	if not point:
		return Vector2()
	return point.global_position

func _filter_inmate_waypoints(waypoint: WayPoint) -> bool:
	return waypoint.waypoint_type == _get_current_waypoint_type(TimeManager.current_routine) and not waypoint.is_guard
	
func _filter_guard_waypoints(waypoint: WayPoint) -> bool:
	return waypoint.waypoint_type == _get_current_waypoint_type(TimeManager.current_routine) and waypoint.is_guard

func _get_current_waypoint_type(routine: Routine) -> WayPointType:
	match routine:
		Routine.ROLL_CALL:
			return WayPointType.ROLL_CALL
		Routine.MEAL_TIME:
			return WayPointType.MEAL_TIME
		Routine.SHOWER_PERIOD:
			return WayPointType.SHOWER
		Routine.GYM_PERIOD:
			return WayPointType.WORK_OUT
	return WayPointType.FREE_PERIOD
