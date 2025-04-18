extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var entity_tree: AnimationTree = $EntityTree

func _ready() -> void:
	nav_agent.target_position = WayPointManager.get_waypoint_warden()

func _physics_process(_delta: float) -> void:
	var dir: Vector2
	if nav_agent.is_navigation_finished():
		nav_agent.target_position = WayPointManager.get_waypoint_warden()
	else:
		dir = global_position.direction_to(nav_agent.get_next_path_position())
		
	if dir:
		#nav_agent.velocity = dir
		const SPEED = 150
		velocity = dir * SPEED
		move_and_slide()
		entity_tree[&"parameters/blend_position"] = dir

#func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	#const SPEED = 150
	#velocity = safe_velocity * SPEED
	#move_and_slide()
