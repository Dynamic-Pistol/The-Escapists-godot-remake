@icon("res://addons/plenticons/icons/64x-hidpi/objects/swords-crossed-blue.png")
extends Area2D
class_name HitBox

#@onready var own_hurt_box: HurtBox = $"../HurtBox"
@export var just_attacked:= false
var target: HurtBox
var attack_timer: SceneTreeTimer

func can_attack() -> bool:
	if not attack_timer:
		return true
	return attack_timer.time_left <= 0 and owner.is_alive()

func filter_enemies(area: Area2D) -> bool:
	if area is not HurtBox:
		return false
	if area.owner == owner:
		return false
	if not owner.is_alive():
		return false
	return WorldLayerManager.both_on_same_layer(area, self)

func attack(enemy: HurtBox) -> void:
	just_attacked = true 
	attack_timer = get_tree().create_timer(owner.get_attack_speed())
	if enemy:
		enemy.damage(owner.get_attack_power())
		if enemy.owner.is_alive():
			enemy.get_node(^"../HitBox").target = get_node(^"../HurtBox")
