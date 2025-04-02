extends Area2D


const PlayerMode = preload("res://Objects/Autoloads/player_manager.gd").PlayerMode;

func _ready() -> void:
	PlayerManager.player_mode_changed.connect(_on_player_mode_changed)

func _on_player_mode_changed(new_mode: PlayerMode):
	%"Target Visual".target = null
	PlayerManager.player.hit_box.target = null
	match new_mode:
		PlayerMode.NORMAL:
			const NORMAL_CURSOR_TEX = preload("res://Sprites/UI/Cursor/Cursor_Normal.png")
			Input.set_custom_mouse_cursor(NORMAL_CURSOR_TEX)
		PlayerMode.USE_ITEM:
			const USE_CURSOR_TEXS = [
					preload("res://Sprites/UI/Cursor/Cursor_Use_1.png"),
					preload("res://Sprites/UI/Cursor/Cursor_Use_2.png"),
					preload("res://Sprites/UI/Cursor/Cursor_Use_3.png"),
					preload("res://Sprites/UI/Cursor/Cursor_Use_4.png"),
			]
			_draw_cursor(new_mode, USE_CURSOR_TEXS)
		PlayerMode.ATTACK:
			const ATTACK_CURSOR_TEXS = [
				preload("res://Sprites/UI/Cursor/Cursor_Attack_1.png"),
				preload("res://Sprites/UI/Cursor/Cursor_Attack_2.png"),
				preload("res://Sprites/UI/Cursor/Cursor_Attack_3.png"),
				preload("res://Sprites/UI/Cursor/Cursor_Attack_4.png"),
			]
			_draw_cursor(new_mode, ATTACK_CURSOR_TEXS)

func _draw_cursor(player_mode: PlayerMode, textures: Array) -> void:
	const FRAME_RATE = 15
	const FRAMES_PER_SECOND = FRAME_RATE / 60.0
	var cursor_index: int = 0
	while PlayerManager.player_mode == player_mode:
		Input.set_custom_mouse_cursor(textures[cursor_index])
		#for i in 15:
				#await get_tree().process_frame
		await get_tree().create_timer(FRAMES_PER_SECOND).timeout 
		cursor_index = wrapi(cursor_index + 1, 0, 4)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	var player_mode = PlayerManager.player_mode
	var player = PlayerManager.player
	var selected_item := PlayerManager.get_selected_item() as Item
	if event.is_action(&"Interact"):
		match  player_mode:
			PlayerMode.NORMAL:
				for body in get_overlapping_bodies():
					if not player.interaction_range.overlaps_body(body):
						continue
					if body.has_method(&"interact"):
						body.interact(player)
						return
				for area in get_overlapping_areas():
					if not player.interaction_range.overlaps_area(area):
						continue
					if area.has_method(&"interact"):
						area.interact(player)
						return
			PlayerMode.USE_ITEM:
				for area in get_overlapping_areas():
					if selected_item is ToolItem:
						if area is Hole:
							if area.can_go_down():
								continue
							area.owning_point.progress += 10
							return
				for body in get_overlapping_bodies():
					if selected_item is ToolItem:
						if body is WorldLayer:
							if selected_item.tool_type == selected_item.ToolType.CHIP and\
								body.layer == WorldLayer.WorldLayerType.GROUND:
								var pos = body.to_local(global_position)
								pos = body.local_to_map(pos)
								body.set_cell(pos, 1, Vector2i(3, 2))
								selected_item.degrade()
								return
							elif selected_item.tool_type == selected_item.ToolType.DIG and\
								body.layer == WorldLayer.WorldLayerType.UNDERGROUND:
								var pos = body.to_local(global_position)
								pos = body.local_to_map(pos)
								body.set_cell(pos, 2, Vector2i(0, 0))
								selected_item.degrade()
								return
				if selected_item is ToolItem and selected_item.tool_type == selected_item.ToolType.DIG:
					if has_overlapping_areas() or has_overlapping_bodies():
						return
					_dig_hole(selected_item)
					return
			PlayerMode.ATTACK:
				for area in get_overlapping_areas():
					if not area.get_parent() == player and area is HurtBox and area.health.is_alive():
						player.hit_box.target = area
						%"Target Visual".target = area
						return
			
	if event.is_action(&"Pickup") and player_mode == PlayerMode.NORMAL:
			if player.picked_up_item != null and player.interaction_range.overlaps_area(self):
				player.picked_up_item.reparent(WorldLayerManager.current_layer)
				player.picked_up_item.global_position = (round(global_position / 32) * 32)
				
				for shape in player.picked_up_item.get_shape_owners():
					player.picked_up_item.shape_owner_set_disabled(shape, false)
				player.picked_up_item = null
				return
			for area in get_overlapping_areas():
				if not player.interaction_range.overlaps_area(area):
					continue
				if area.is_in_group(&"pickable"):
					area.pick_up(player)
					break
			for body in get_overlapping_bodies():
				if not player.interaction_range.overlaps_body(body) or body == player:
					continue
				if body.is_in_group(&"pickable"):
					for shape in body.get_shape_owners():
						body.shape_owner_set_disabled(shape, true)
					body.reparent(player)
					body.position = Vector2.ZERO
					player.picked_up_item = body
					break

func _dig_hole(dig_tool: ToolItem) -> void:
	dig_tool.degrade()
	var hole_point := HolePoint.new()
	var layer := WorldLayerManager.current_layer
	
	var target_pos := layer.to_local(global_position)
	target_pos = layer.local_to_map(target_pos)
	target_pos = layer.map_to_local(target_pos)
	target_pos = layer.to_global(target_pos)
	
	hole_point.global_position = target_pos
	get_tree().root.add_child(hole_point)
