extends "res://Objects/ItemSystem/ItemTypes/usable_item.gd"
class_name KeyItem

enum KeyType{
	INVALID = -1,
	CELL,
	ENTERANCE,
	UTILITY,
	WORK,
	STAFF,
}

@export var key_type: KeyType
@export var fake: bool
@export var decay := 10
