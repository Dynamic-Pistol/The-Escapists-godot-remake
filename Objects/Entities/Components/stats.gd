extends Node
class_name Stats

#region
#endregion

var intellect: int = 50
var strength: int = 50
var speed: int = 50

func get_strength() -> int:
	@warning_ignore("integer_division")
	return strength / 10
