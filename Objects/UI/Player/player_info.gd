extends Control

@onready var int_bar: TextureProgressBar = $"INT Bar"
@onready var str_bar: TextureProgressBar = $"STR Bar"
@onready var spd_bar: TextureProgressBar = $"SPD Bar"

func _on_visibility_changed() -> void:
	if not visible:
		return
	int_bar.value = owner.intellect
	str_bar.value = owner.strength
	spd_bar.value = owner.speed
