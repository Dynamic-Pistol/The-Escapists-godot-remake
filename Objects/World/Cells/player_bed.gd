extends StaticBody2D


func interact(player: Player) -> void:
	player.sleeping = not player.sleeping
	if player.sleeping:
		player.global_position = global_position
		var time_speed = TimeManager.time_speed
		const FAST_TIME_SPEED = 15
		while player.sleeping and TimeManager.time_speed < FAST_TIME_SPEED:
			time_speed = lerpf(time_speed, FAST_TIME_SPEED, get_process_delta_time())
			TimeManager.time_speed = time_speed
			await get_tree().process_frame
	else:
		TimeManager.time_speed = 1
		player.global_position = $"DropOff".global_position
