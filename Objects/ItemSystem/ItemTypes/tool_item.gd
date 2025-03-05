extends "res://Objects/ItemSystem/ItemTypes/usable_item.gd"
class_name ToolItem

enum ToolType{
	CHIP,
	DIG,
	CUT,
}


var durability := 100
var decay := 10
var power := 10
var tool_type: ToolType
