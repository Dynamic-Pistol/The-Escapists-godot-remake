extends Entity


@export var nav_agent: NavigationAgent2D
var current_point: Vector2
@export var enemy_target: Entity

@export var player_opinion:= 100

const INMATE_NAMES = ["Glenn", "Rick", "Mike", "Flint", "Paul"]

@export var hit_box: NPCHitBox

func _ready() -> void:
	$InteractableRange.name = INMATE_NAMES.pick_random()
	if enemy_target:
		hit_box.target = enemy_target.get_node(^"HurtBox")
	TimeManager.routine_changed.connect(_on_routine_changed)

func _physics_process(_delta: float) -> void:
	if not is_alive():
		return
	move()

func move() -> void:
	if hit_box.target:
		nav_agent.target_position = hit_box.target.global_position
	elif nav_agent.is_navigation_finished():
		if TimeManager.current_routine == TimeManager.Routine.FREE_TIME:
			nav_agent.target_position = WayPointManager.get_waypoint_no_consume()
		else:
			nav_agent.target_position = current_point
	var dir:Vector2 = global_position.direction_to(nav_agent.get_next_path_position())
	if nav_agent.is_target_reached():
		dir = Vector2()
	
	if dir:
		#nav_agent.velocity = dir
		velocity = dir * get_move_speed()
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir
		anim_tree[&"parameters/Attack/blend_position"] = dir

func _on_routine_changed() -> void:
	current_point = WayPointManager.get_waypoint(false)
	nav_agent.target_position = current_point

func hates_player() -> bool:
	return player_opinion < 30

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity * get_move_speed()
	move_and_slide()

func _on_knocked_out() -> void:
	hit_box.monitoring = false
	add_to_group(&"pickable")
	await get_tree().create_timer(25).timeout
	hit_box.monitoring = true
	remove_from_group(&"pickable")
	revive()
