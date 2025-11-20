extends Button

func _pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
	TimeManager.set_process(true)
	MusicPlayer.game_started()
