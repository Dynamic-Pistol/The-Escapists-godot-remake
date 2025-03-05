@tool
extends StaticBody2D

enum KeyType{
	NONE = 0,
	CELL,
	ENTERANCE,
	UTILITY,
	WORK,
	STAFF,
	GUARD,
	WARDEN
}

@export var door_key_type: KeyType:
	set(new_val):
		door_key_type = new_val
		$Visual.frame = door_key_type


func _ready() -> void:
	$Visual.frame = door_key_type

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Entity or body.collision_mask != collision_layer:
		return
	if body is Player and door_key_type != KeyType.NONE:
		var inventory :Inventory = body.inventory
		if door_key_type == KeyType.WARDEN:
			return
		elif door_key_type == KeyType.GUARD and inventory.outfit.outfit_type != OutfitItem.OutfitType.Guard:
			return
		elif not inventory.has_key(door_key_to_item_key(door_key_type)):
			return
	$CollisionShape2D.set_deferred(&"disabled", true)
	$Visual.visible = false
	$Sound.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Entity or body.collision_mask != collision_layer:
		return
	if $Area2D.get_overlapping_bodies().size() > 0:
		return
	$CollisionShape2D.set_deferred(&"disabled", false)
	$Visual.visible = true
	$Sound.play()

func door_key_to_item_key(door_key: KeyType) -> KeyItem.KeyType:
	const ItemKeyType = KeyItem.KeyType
	match door_key:
		KeyType.CELL:
			return ItemKeyType.CELL
		KeyType.ENTERANCE:
			return ItemKeyType.ENTERANCE
		KeyType.UTILITY:
			return ItemKeyType.UTILITY
		KeyType.WORK:
			return ItemKeyType.WORK
		KeyType.STAFF:
			return ItemKeyType.STAFF
	return ItemKeyType.INVALID
