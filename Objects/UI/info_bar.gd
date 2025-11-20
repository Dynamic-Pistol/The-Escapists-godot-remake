extends Range

@export var info_name: StringName

func _on_visibility_changed() -> void:
	value = owner[info_name]

func _get_tooltip(_at_position: Vector2) -> String:
	return "%s: %d" % [info_name, value]
