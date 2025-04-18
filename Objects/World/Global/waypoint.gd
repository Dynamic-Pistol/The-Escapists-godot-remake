extends Node2D
class_name WayPoint

enum WayPointType{
	ROLL_CALL,
	MEAL_TIME,
	WORK_OUT,
	SHOWER,
	FREE_PERIOD,
	WARDEN
}

@export var waypoint_type: WayPointType
