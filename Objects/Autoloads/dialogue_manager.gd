extends Node

var config := ConfigFile.new()

func _ready() -> void:
	config.load("res://Tools/speech_eng.txt")

func get_basic() -> String:
	return config.get_value("Banter", str(randi_range(1, 228)))
