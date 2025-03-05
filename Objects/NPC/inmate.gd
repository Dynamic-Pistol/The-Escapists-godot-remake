extends Entity

@export
var nav_agent: NavigationAgent2D
var map_rid: RID

func _on_timer_timeout() -> void:
	if not alive:
		return
	$Timer.wait_time = randf_range(8, 25)
	$Label.text = DialogueManager.get_basic()
	$Label.visible = true
	await get_tree().create_timer(len($Label.text) / 2.0).timeout
	$Label.visible = false

func _ready() -> void:
	map_rid = nav_agent.get_navigation_map()
	set_physics_process(false)
	call_deferred(&"setup_nav")

func setup_nav() -> void:
	await NavigationServer2D.map_changed
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	if not alive:
		return
	move()

func move() -> void:
	if nav_agent.is_navigation_finished():
		nav_agent.target_position = NavigationServer2D.map_get_random_point(map_rid, nav_agent.navigation_layers, false)
	var dir = global_position.direction_to(nav_agent.get_next_path_position())
	if dir:
		const SPEED = 300.0
		nav_agent.velocity = velocity
		velocity = dir * SPEED
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir
	
