@icon("res://addons/plenticons/icons/64x-hidpi/objects/clock-gray.png")
extends Node

enum Routine{
	LIGHTS_OUT,
	ROLL_CALL,
	FREE_TIME,
	MEAL_TIME,
	GYM_PERIOD,
	SHOWER_PERIOD,
	WORK_PERIOD
}

signal routine_changed

var minutes := 50.0
var hours := 7
var days := 1
var current_routine := Routine.LIGHTS_OUT
var meal_time_count := 0

const DAY_LENGTH = 24
var time_speed: float = 1

var routines: PackedInt32Array

func _ready() -> void:
	var text = FileAccess.get_file_as_string("res://Resources/routines.json")
	var json = JSON.new()
	var err = json.parse(text)
	if err != OK:
		return
	routines = json.data as PackedInt32Array                                           

func _process(delta: float) -> void:
	minutes += delta * time_speed
	if minutes >= 60:
		minutes = 0
		hours += 1
	if hours >= DAY_LENGTH:
		hours = 0
		days += 1
		meal_time_count = 0
	var new_routine = routines[hours] as Routine
	if current_routine != new_routine:
		current_routine = new_routine
		if current_routine == Routine.MEAL_TIME:
			meal_time_count += 1
		routine_changed.emit()

func get_time_sample() -> float:
	return (hours + (minutes / 60)) / DAY_LENGTH

func get_time_format() -> String:
	
	return "%02d:%02d %s (Day %d)" % [hours, minutes, get_routine_name(current_routine), days]

func get_routine_name(routine: Routine) -> String:
	match routine:
		Routine.LIGHTS_OUT:
			return "Lights out"
		Routine.ROLL_CALL:
			return "Roll call"
		Routine.FREE_TIME:
			return "Free time"
		Routine.MEAL_TIME:
			if meal_time_count == 1:
				return "Breakfast"
			elif meal_time_count == 2:
				return "Lunch"
			elif meal_time_count == 3:
				return "Dinner"
			else:
				return "Meal time"
		Routine.GYM_PERIOD:
			return "Gym period"
		Routine.SHOWER_PERIOD:
			return "Shower period"
		Routine.WORK_PERIOD:
			return "Leisure period"
	return "routine"
