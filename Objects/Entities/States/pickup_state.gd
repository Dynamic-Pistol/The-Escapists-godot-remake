@icon("res://Editor Icons/carry.png")
extends State
class_name PickUpState

@export
var interactor: Interactor

func enter() -> void:
	interactor.interact()
	transition.emit("Move")
