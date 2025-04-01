extends Node

const WayPointType = preload("res://Objects/World/Global/waypoint.gd").WayPointType
const Routine = TimeManager.Routine

var waypoints: Array[WayPoint]
var unused_waypoints: Array[WayPoint]

func _ready() -> void:
	var points = get_tree().get_nodes_in_group(&"waypoint")
	waypoints.assign(points)
	TimeManager.routine_changed.connect(_on_routine_changed)

func _on_routine_changed() -> void:
	unused_waypoints.clear()
	unused_waypoints.assign(waypoints.filter(_filter_waypoints))

func get_waypoint() -> Vector2:
	unused_waypoints.shuffle()
	var point: WayPoint = unused_waypoints.pop_at(0)
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
