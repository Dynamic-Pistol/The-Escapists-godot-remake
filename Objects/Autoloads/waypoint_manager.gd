extends Node

const WayPointType = preload("res://Objects/World/Global/waypoint.gd").WayPointType
const Routine = TimeManager.Routine

var _waypoints: Array[WayPoint]
var _unused_waypoints: Array[WayPoint]
var _warden_waypoints: Array[WayPoint]

func _ready() -> void:
	var points = get_tree().get_nodes_in_group(&"waypoint")
	_waypoints.assign(points)
	_warden_waypoints.assign(_waypoints.filter(func(w: WayPoint): return w.waypoint_type == WayPointType.WARDEN))
	TimeManager.routine_changed.connect(_on_routine_changed)

func _on_routine_changed() -> void:
	_unused_waypoints.clear()
	_unused_waypoints.assign(_waypoints.filter(_filter_waypoints))

func get_waypoint() -> Vector2:
	_unused_waypoints.shuffle()
	var point: WayPoint = _unused_waypoints.pop_at(0)
	if not point:
		return Vector2()
	return point.global_position

func get_waypoint_no_consume() -> Vector2:
	var point = _waypoints.filter(_filter_waypoints).pick_random()
	if not point:
		return Vector2()
	return point.global_position
	
func get_waypoint_warden() -> Vector2:
	var point = _warden_waypoints.pick_random()
	if not point:
		return Vector2()
	return point.global_position

func _filter_waypoints(waypoint: WayPoint) -> bool:
	return waypoint.waypoint_type == _get_current_waypoint_type(TimeManager.current_routine)

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
