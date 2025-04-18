extends InteractableEntity
class_name Player

const PlayerCursor = preload("res://Objects/Entities/Player/player_cursor.gd")


var picked_up_item: PhysicsBody2D
var current_keys: int = 1
var sleeping: bool


@onready var stats: Stats = $Stats
@onready var hit_box: PlayerHitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox
@onready var health: Health = $Health
@onready var cursor : PlayerCursor = $PlayerCursor
@onready var interaction_range: Area2D = $InteractionRange

func _physics_process(_delta: float) -> void:
	if not health.is_alive() or sleeping:
		return
	_player_move()
	if Input.is_action_just_pressed(&"Block") and not hurt_box.blocking:
		hurt_box.block()

func _player_move() -> void:
	var dir := Input.get_vector(&"Left", &"Right", &"Back", &"Forward")
	if dir:
		var speed = stats.get_move_speed()
		velocity = dir * speed
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir
		anim_tree[&"parameters/Attack/blend_position"] = dir

func switch_layer(layer_id: int) -> void:
	collision_mask = 1 << layer_id
	$InteractionRange.collision_mask = collision_mask | 1 << 4
	cursor.collision_mask = collision_mask | 1 << 4
