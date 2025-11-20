extends StaticBody2D

@export var drop_off: Node2D

func interact(interactor: Entity) -> void:
	interactor.sleeping = not interactor.sleeping
	if interactor.sleeping:
		interactor.global_position = global_position
		var time_speed = TimeManager.time_speed
		const FAST_TIME_SPEED = 15
		while interactor.sleeping and TimeManager.time_speed < FAST_TIME_SPEED:
			time_speed = lerpf(time_speed, FAST_TIME_SPEED, get_process_delta_time())
			TimeManager.time_speed = time_speed
			await get_tree().process_frame
	else:
		TimeManager.time_speed = 1
		interactor.global_position = drop_off.global_position
