extends CanvasModulate

@export
var gradient: Gradient

func _process(_delta: float) -> void:
	color = gradient.sample(TimeManager.get_time_sample())
