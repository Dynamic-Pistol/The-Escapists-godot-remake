extends Area2D
const NORMAL_CURSOR_TEX = preload("res://Sprites/UI/Cursor/Cursor_Normal.png")
const USE_CURSOR_TEXS = [
	preload("res://Sprites/UI/Cursor/Cursor_Use_1.png"),
	preload("res://Sprites/UI/Cursor/Cursor_Use_2.png"),
	preload("res://Sprites/UI/Cursor/Cursor_Use_3.png"),
	preload("res://Sprites/UI/Cursor/Cursor_Use_4.png"),
]
const ATTACK_CURSOR_TEXS = [
	preload("res://Sprites/UI/Cursor/Cursor_Attack_1.png"),
	preload("res://Sprites/UI/Cursor/Cursor_Attack_2.png"),
	preload("res://Sprites/UI/Cursor/Cursor_Attack_3.png"),
	preload("res://Sprites/UI/Cursor/Cursor_Attack_4.png"),
]

enum CursorState{
	NORMAL,
	USE,
	ATTACK,
}


var cursor_state := CursorState.NORMAL:
	set(new_value):
		if cursor_state == CursorState.ATTACK:
			%"Target Visual".target = null
			player.hit_box.target = null
		cursor_state = new_value
		match cursor_state:
			CursorState.NORMAL:
				Input.set_custom_mouse_cursor(NORMAL_CURSOR_TEX)
			CursorState.USE:
				var cursor_index: int = 0
				while cursor_state == CursorState.USE:
					Input.set_custom_mouse_cursor(USE_CURSOR_TEXS[cursor_index])
					for i in 15:
						await get_tree().process_frame
					cursor_index = wrapi(cursor_index + 1, 0, 4)
			CursorState.ATTACK:
				var cursor_index: int = 0
				while cursor_state == CursorState.ATTACK:
					Input.set_custom_mouse_cursor(ATTACK_CURSOR_TEXS[cursor_index])
					for i in 15:
						await get_tree().process_frame
					cursor_index = wrapi(cursor_index + 1, 0, 4)

@onready var player:Player = get_parent()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action(&"Attack"):
			cursor_state = CursorState.ATTACK if cursor_state == CursorState.NORMAL else CursorState.NORMAL
		if event is InputEventMouseButton and event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			var layer := WorldLayerManager.current_layer
			if layer.tile_is_destroyed(global_position):
				layer.fix_tile(global_position)
			else:
				layer.destroy_tile(global_position)
		if event.is_action(&"Interact"):
			for area in get_overlapping_areas():
				match cursor_state:
					CursorState.NORMAL:
						if not player.interaction_range.overlaps_area(area):
							return
						if area.has_method(&"interact"):
							area.interact(player)
					CursorState.USE:
						pass
					CursorState.ATTACK:
						if not area.get_parent() == player and area is HurtBox and area.health.is_alive():
							player.hit_box.target = area
							%"Target Visual".target = area
							return
		if event.is_action(&"Pickup") and cursor_state == CursorState.NORMAL:
			if player.picked_up_item != null and player.interaction_range.overlaps_area(self):
				player.picked_up_item.reparent(WorldLayerManager.current_layer)
				player.picked_up_item.global_position = (round(global_position / 32) * 32)
				
				player.picked_up_item = null
				return
			for area in get_overlapping_areas():
				if not player.interaction_range.overlaps_area(area):
					continue
				if area.is_in_group(&"pickable"):
					if area is HurtBox:
						area.get_parent().pick_up(player)
					else:
						area.pick_up(player)
					break
			for body in get_overlapping_bodies():
				if not player.interaction_range.overlaps_body(body) or body == player:
					continue
				if body.is_in_group(&"pickable"):
					body.pick_up(player)
					break
		
