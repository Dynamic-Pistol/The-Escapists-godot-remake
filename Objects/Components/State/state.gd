extends Node
class_name State

@warning_ignore("unused_signal")
signal transition(state_name: StringName)

var agent: Entity

func init() -> void:pass
func enter() -> void:pass
func exit() -> void:pass
func update(_delta: float) -> void:pass
func phy_update(_delta: float) -> void:pass
func input(_event: InputEvent) -> void:pass
