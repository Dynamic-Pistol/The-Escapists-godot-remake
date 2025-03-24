extends UsableItem
class_name ToolItem

enum ToolType{
	CHIP,
	DIG,
	CUT,
}


var decay := 10
var power := 10
var tool_type: ToolType
