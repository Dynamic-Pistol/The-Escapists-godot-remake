extends Area2D
class_name HitBox

@onready var health: Health = $"../Health"
@onready var stats: Stats = $"../Stats"
@onready var own_hurt_box: HurtBox = $"../HurtBox"
@export var just_attacked:= false
var target: HurtBox
var attack_timer: SceneTreeTimer

func can_attack() -> bool:
	if not attack_timer:
		return true
	return attack_timer.time_left <= 0 and health.is_alive()

func filter_enemies(area: Area2D) -> bool:
	if area is not HurtBox:
		return false
	if area == own_hurt_box:
		return false
	if not area.get_parent().collision_mask & get_parent().collision_mask:
		return false
	if not area.health.is_alive():
		return false
	return true

func attack(enemy: HurtBox) -> void:
	just_attacked = true 
	attack_timer = get_tree().create_timer(stats.get_attack_speed())
	if enemy:
		enemy.damage(stats.get_attack_power())
		enemy.get_node(^"../HitBox").target = get_node(^"../HurtBox")
