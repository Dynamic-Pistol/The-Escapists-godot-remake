extends Entity
class_name Player

#region Player Mode

enum PlayerMode{
	NORMAL = 1 << 0,
	ATTACK = 1 << 1,
	USE_ITEM = 1 << 2,
}

signal player_mode_changed(new_mode: PlayerMode)

var player_mode: PlayerMode = PlayerMode.NORMAL:
	set(new_val):
		if player_mode == new_val:
			return
		player_mode = new_val
		player_mode_changed.emit(player_mode)
#endregion

#region Inventory
var _selected_item: int = -1:
	set(new_value):
		_selected_item = new_value
		if _selected_item == -1:
			player_mode = PlayerMode.NORMAL
		else:
			player_mode = PlayerMode.USE_ITEM

func get_selected_item() -> Item:
	return items[_selected_item]

func select_item(index: int) -> void:
	_selected_item = index

func drop_item(index: int) -> void:
	var item = items[index]
	items[index] = null
	inventory_changed.emit(index, null)
	item_removed.emit(index, item)
	const ITEM_DROP = preload("res://Objects/ItemSystem/item_drop.tscn")
	var item_drop = ITEM_DROP.instantiate()
	item_drop.item = item
	item_drop.global_position = global_position
	WorldLayerManager.current_layer.add_child(item_drop)

func _on_item_added(index: int, item: Item) -> void:
	if item is UsableItem:
		item.item_used.connect(_durability_changed.bind(index))
		if item is KeyItem:
			current_keys |= item.key_type

func _on_item_removed(index: int, item: Item) -> void:
	if _selected_item == index:
		_selected_item = -1
	if item is UsableItem:
		item.item_used.disconnect(_durability_changed.bind(index))
		if item is KeyItem:
			current_keys &= ~item.key_type

func _durability_changed(new_durability: int, item_idx: int) -> void:
	if new_durability <= 0:
		remove_item(item_idx)
#endregion

#region Health
@onready var heal_timer: Timer = $HealTimer

func _on_damaged(_new_health: int) -> void:
	if heal_timer.is_stopped():
		heal_timer.start()

func _on_healed(new_health: int) -> void:
	if new_health == get_max_health():
		heal_timer.stop()

func _on_heal_timer_timeout() -> void:
	heal(1)
#endregion

var picked_up_item: PhysicsBody2D
var current_keys: int = 0

@onready var cursor : PlayerCursor = $PlayerCursor
@onready var interaction_range: Area2D = $InteractionRange
@onready var hit_box: PlayerHitBox = $HitBox
@export var rect_mat: ShaderMaterial

func _move() -> void:
	var dir := Input.get_vector(&"Left", &"Right", &"Back", &"Forward")
	if dir:
		velocity = dir * get_move_speed()
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir
		anim_tree[&"parameters/Attack/blend_position"] = dir

func _ready() -> void:
	items.resize(24)
	outfit = preload("res://Resources/Test Items/inmate_outfit.tres")

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	if event.is_action(&"To Attack"):
		player_mode = PlayerMode.ATTACK if player_mode == PlayerMode.NORMAL else PlayerMode.NORMAL

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_O:
			revive()
