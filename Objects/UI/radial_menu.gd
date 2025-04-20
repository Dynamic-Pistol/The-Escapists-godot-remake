extends Control
class_name RadialMenu

const SPRITE_SIZE = Vector2(128, 128)

const OUTER_RADIUS = 350
const INNER_RADIUS := 100

const BG_COLOR := Color.WEB_GRAY
const LINE_COLOR := Color.LIGHT_SLATE_GRAY
const HIGHTLIGHT_COLOR := Color(Color.AQUA, 0.75)

const LINE_WIDTH  = 4

var selection := 0

#
#func _ready() -> void:
	#if Engine.is_editor_hint():
		#return
	#PlayerManager.player.inventory.inventory_changed.connect(_on_inventory_changed)
#
#func _on_inventory_changed(index: int, item: Item) -> void:
	#pass

func _draw() -> void:
	draw_circle(Vector2(), INNER_RADIUS, BG_COLOR)
	draw_circle(Vector2(), OUTER_RADIUS, LINE_COLOR, false, LINE_WIDTH, true)
	
	if selection == -1:
		draw_circle(Vector2(), INNER_RADIUS, HIGHTLIGHT_COLOR)
		
	var items_count := 6
	
	for i in items_count:
		var rads = i * TAU / items_count
		var point = Vector2.from_angle(rads)
		draw_line(point * INNER_RADIUS,
		point * OUTER_RADIUS, 
		LINE_COLOR,
		LINE_WIDTH,
		true)
		
	const CLEAR_TEXTURE = preload("res://Sprites/UI/Icons/Cancel.png")
	draw_texture(CLEAR_TEXTURE, Vector2(-26, -26))
	
	for i in items_count + 1:
		const OFFSET = SPRITE_SIZE / -2
		var start_rads := TAU * (i - 1) / items_count
		var end_rads := TAU * i / items_count
		var mid_rads := (start_rads + end_rads) / -2.0
		var mid_radius := (INNER_RADIUS + OUTER_RADIUS) / 2.0
		
		var draw_position = mid_radius * Vector2.from_angle(mid_rads) + OFFSET
		
		if selection == i:
			const POINTS_PER_ARC = 32
			var points_inner = PackedVector2Array()
			var points_outer = PackedVector2Array()
			
			for j in POINTS_PER_ARC + 1:
				var angle = start_rads + j * (end_rads - start_rads) / POINTS_PER_ARC
				points_inner.append(INNER_RADIUS * Vector2.from_angle(TAU - angle))
				points_outer.append(OUTER_RADIUS * Vector2.from_angle(TAU - angle))
			
			points_outer.reverse()
			draw_polygon(
				points_inner + points_outer,
				PackedColorArray([HIGHTLIGHT_COLOR])
			)
		
		var rect: Rect2
		rect.position = draw_position
		rect.size = 128 * Vector2.ONE
		var item = PlayerManager.items[i - 1]
		if item:
			draw_texture_rect(item.texture, rect, false)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos = get_local_mouse_position()
		var mouse_radius = mouse_pos.length()
		
		if mouse_radius < INNER_RADIUS:
			selection = -1
		else:
			var mouse_rads = fposmod(-mouse_pos.angle(), TAU)
			selection = ceili((mouse_rads / TAU) * PlayerManager.items.size())
		queue_redraw()
		
	if event.is_action_pressed(&"Quick Wheel"):
		show()
	elif event.is_action_released(&"Quick Wheel"):
		hide()
		if PlayerManager.has_item_at(selection - 1):
			PlayerManager.drop_item(selection - 1)
