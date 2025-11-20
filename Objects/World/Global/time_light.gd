extends DirectionalLight2D

@export var _light_curve: Curve

func _process(_delta: float) -> void:
	energy = _light_curve.sample(TimeManager.get_time_sample())
