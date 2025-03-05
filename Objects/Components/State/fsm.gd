@icon("res://Editor Icons/fsm.png")
extends Node
class_name FSM

@export
var agent: Entity
var states := {}
@export
var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for state in get_children():
		if state is State:
			states[state.name] = state
			if not current_state:
				current_state = state
			state.transition.connect(change_state)
			state.agent = agent
			state.init()
	if current_state:
		current_state.enter()

func _process(delta: float) -> void:
	if agent.alive:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if agent.alive:
		current_state.phy_update(delta)

func _input(event: InputEvent) -> void:
	if agent.alive:
		current_state.input(event)

func change_state(state_name: StringName) -> void:
	if states.has(state_name) and current_state != states[state_name]:
		current_state.exit()
		current_state = states[state_name]
		current_state.enter()
	else:
		push_warning("State doesn't exist!")
