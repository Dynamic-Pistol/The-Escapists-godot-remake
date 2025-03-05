extends GetMove
class_name PlayerGetMove

func get_move() -> Vector2:
	return Input.get_vector(&"Left", &"Right", &"Back", &"Forward")
