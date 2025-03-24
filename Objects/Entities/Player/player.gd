extends InteractableEntity
class_name Player

const PlayerCursor = preload("res://Objects/Entities/Player/player_cursor.gd")


var picked_up_item: PhysicsBody2D
var current_keys: int = 1

@onready var cursor : PlayerCursor = $PlayerCursor
@onready var interaction_range: Area2D = $InteractionRange
@onready var hit_box: HitBox = $HitBox
@export var inventory: PlayerInventory

func _ready() -> void:
	PlayerManager.player = self

func _physics_process(_delta: float) -> void:
	if not health.is_alive():
		return
	_player_move()


func _player_move() -> void:
	var dir := Input.get_vector(&"Left", &"Right", &"Back", &"Forward")
	if dir:
		const SPEED = 362.5
		velocity = dir * SPEED
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir
		anim_tree[&"parameters/Attack/blend_position"] = dir

func switch_layer(layer_id: int) -> void:
	collision_mask = 1 << layer_id
	$InteractionRange.collision_mask = collision_mask | 1 << 4
	cursor.collision_mask = collision_mask | 1 << 4


func _on_item_removed(item: Item) -> void:
	const ITEM_DROP = preload("res://Objects/ItemSystem/item_drop.tscn")
	var item_drop = ITEM_DROP.instantiate()
	item_drop.collision_layer = collision_mask | 1 << 4
	item_drop.item = item
	WorldLayerManager.current_layer.add_child(item_drop)
	item_drop.global_position = global_position.snappedf(64).floor()
