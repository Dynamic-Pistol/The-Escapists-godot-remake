extends CharacterBody2D
class_name Entity

#region Inventory
signal inventory_changed(index: int, item: Item)
signal item_added(index: int,item: Item)
signal item_removed(index: int, item: Item)
signal desk_opened(desk: Desk)
signal desk_closed
signal equipment_changed(index: int, item: Item)

var items: Array[Item]
var weapon: WeaponItem
var outfit: OutfitItem:
	set(new_val):
		outfit = new_val
		if outfit:
			$Clothes.texture = outfit.outfit_visual
		else:
			$Clothes.texture = null
		equipment_changed.emit(0, outfit)

func add_item(item: Item) -> bool:
	for i in items.size():
		if items[i] == null:
			items[i] = item.duplicate(true)
			inventory_changed.emit(i, items[i])
			item_added.emit(i, items[i])
			return true
	return false

func set_item(item: Item, index: int) -> bool:
	if not item:
		remove_item(index)
		return true
	if items[index] == null:
		items[index] = item.duplicate(true)
		inventory_changed.emit(index, items[index])
		item_added.emit(index, items[index])
		return true
	return false

func swap_items(my_item: int, other_item: int, other_container: Variant) -> void:
	var my_temp: Item = items[my_item]
	remove_item(my_item)
	var other_temp: Item = other_container.items[other_item]
	other_container.remove_item(other_item)
	set_item(other_temp, my_item)
	other_container.set_item(my_temp, other_item)

func remove_item(index: int) -> void:
	var item = items[index]
	items[index] = null
	inventory_changed.emit(index, null)
	item_removed.emit(index, item)

func remove_illegals() -> void:
	for i in items.size():
		if items[i].is_contraband:
			remove_item(i)

func has_illegals() -> bool:
	return items.any(func(i: Item): return i and i.is_contraband)

func has_item_at(index: int) -> bool:
	return items[index] != null

func open_desk(desk: Desk) -> void:
	desk_opened.emit(desk)

func close_desk() -> void:
	desk_closed.emit()

#endregion

#region Stats
@export_range(1, 100) var intellect: int = 50
@export_range(1, 100) var strength: int = 50
@export_range(1, 100) var speed: int = 50

func get_attack_power() -> int:
	@warning_ignore("integer_division")
	return strength / 15

func get_attack_speed() -> float:
	return 20.0 / speed

func get_move_speed() -> float: 
	return maxf(speed * 6, 250.0)

#region Health

signal health_changed(new_health: int)
signal damaged(new_health: int)
signal healed(new_health: int)
signal knocked_out

@onready var _health := get_max_health():
	set(new_val):
		_health = new_val
		health_changed.emit(_health)

func is_alive() -> bool:
	return _health > 0

func get_max_health() -> int:
	return maxi(floori(strength / 2.0), 5)

func revive() -> void:
	_health = get_max_health()

func damage(amount: int) -> void:
	_health -= amount
	damaged.emit(_health)
	if _health <= 0:
		knocked_out.emit()

func heal(amount: int) -> void:
	_health += amount
	_health = mini(_health, get_max_health())
	healed.emit(_health)

func get_health() -> int:
	return _health

#endregion
#endregion

var sleeping: bool
@export var anim_tree: AnimationTree


func _physics_process(_delta: float) -> void:
	if not is_alive() or sleeping:
		return
	_move()

func _move() -> void:
	pass
