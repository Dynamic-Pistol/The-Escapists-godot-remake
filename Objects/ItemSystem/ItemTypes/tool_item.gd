extends UsableItem
class_name ToolItem

enum ToolType {
	CHIP,
	DIG,
	CUT,
}

@export var power := 10
@export var tool_type: ToolType
