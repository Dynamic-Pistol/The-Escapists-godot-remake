extends InteractableEntity

@onready var stats: NpcStats = $Stats
@onready var health: Health = $Health
@onready var hit_box: NPCHitBox = $HitBox

@export var nav_agent: NavigationAgent2D
var current_point: Vector2
var move_again: bool = true

@export var enemy_target: InteractableEntity
@export var player_opinion: int = -1

const INMATE_NAMES = ["Glenn", "Rick", "Mike", "Flint", "Paul"]

func _ready() -> void:
	$InteractableRange.name = INMATE_NAMES.pick_random()
	if enemy_target:
		hit_box.target = enemy_target.get_node(^"HurtBox")
	if player_opinion >= 0:
		stats.player_opinion = player_opinion
	TimeManager.routine_changed.connect(_on_routine_changed)

func _physics_process(_delta: float) -> void:
	if not health.is_alive():
		return
	move()
	if stats.hates_player():
		hit_box.target = PlayerManager.player.get_node(^"HurtBox")

func move() -> void:
	var dir:= Vector2()
	if hit_box.target:
		nav_agent.target_position = hit_box.target.global_position
	elif nav_agent.is_navigation_finished():
		if TimeManager.current_routine == TimeManager.Routine.FREE_TIME:
			nav_agent.target_position = WayPointManager.get_waypoint_no_consume()
		else:
			nav_agent.target_position = current_point
	if not nav_agent.is_navigation_finished():
		dir = global_position.direction_to(nav_agent.get_next_path_position())
		
	if dir:
		#nav_agent.velocity = dir
		var speed = stats.get_move_speed()
		velocity = dir * speed
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir
		anim_tree[&"parameters/Attack/blend_position"] = dir

func _on_routine_changed() -> void:
	current_point = WayPointManager.get_waypoint()

func _on_health_knocked_out() -> void:
	%HitBox.monitoring = false
	add_to_group(&"pickable")
	await get_tree().create_timer(8).timeout
	%HitBox.monitoring = true
	remove_from_group(&"pickable")
	health.revive()

#func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	#if not health.is_alive():
		#return
	#var speed = stats.get_move_speed()
	#velocity = safe_velocity * speed
	#move_and_slide()
