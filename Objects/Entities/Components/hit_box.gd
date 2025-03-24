extends Area2D
class_name HitBox

var can_attack:= true
@export var stats: Stats
@export var just_attacked:= false
@onready var entity = get_parent()
var target: HurtBox

func _on_enemy_entered(area: Area2D) -> void:
	#if not body.is_in_group(&"attackable"):
		#return
	if area is not HurtBox:
		return
	if not can_attack:
		return
	if not area.health.is_alive():
		return
	if target != area:
		return
	while area.health.is_alive() and overlaps_area(area):
		can_attack = false
		attack(area)
		await $AttackTimer.timeout
		can_attack = true

func attack(enemy: HurtBox) -> void:
	just_attacked = true
	%HitSfx.play()
	$AttackTimer.start()
	enemy.damage(stats.get_strength())
