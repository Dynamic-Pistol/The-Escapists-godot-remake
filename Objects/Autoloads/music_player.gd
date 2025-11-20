extends AudioStreamPlayer

const Routine = preload("res://Objects/Autoloads/time_manager.gd").Routine

const MUSIC = {
	Routine.LIGHTS_OUT: preload("res://Audio/Music/lightsout.ogg"),
	Routine.ROLL_CALL: preload("res://Audio/Music/rollcall.ogg"),
	Routine.FREE_TIME: preload("res://Audio/Music/perks.ogg"),
	Routine.MEAL_TIME: preload("res://Audio/Music/chow.ogg"),
	Routine.GYM_PERIOD: preload("res://Audio/Music/workout.ogg"),
	Routine.SHOWER_PERIOD: preload("res://Audio/Music/shower.ogg"),
	Routine.WORK_PERIOD: preload("res://Audio/Music/work.ogg")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeManager.routine_changed.connect(routine_changed)

func game_started() -> void:
	routine_changed()

func routine_changed() -> void:
	stream = MUSIC[TimeManager.current_routine]
	play()
