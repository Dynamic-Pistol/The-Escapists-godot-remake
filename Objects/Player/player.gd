extends Entity
class_name Player

const NORMAL_CURSOR_TEX = preload("res://Sprites/UI/Cursor/Cursor_Normal.png")
const USE_CURSOR_TEX = preload("res://Sprites/UI/Cursor/Cursor_Use_1.png")

enum CursorState{
	NORMAL,
	USE,
	ATTACK,
}

var cursor_state := CursorState.NORMAL:
	set(new_value):
		cursor_state = new_value
		match cursor_state:
			CursorState.NORMAL:
				Input.set_custom_mouse_cursor(NORMAL_CURSOR_TEX)
			CursorState.USE:
				Input.set_custom_mouse_cursor(USE_CURSOR_TEX)
			CursorState.ATTACK:
				pass

var target_enemy: Entity = null


func _ready() -> void:
	PlayerManager.player = self

func _physics_process(_delta: float) -> void:
	if not alive:
		return
	move()
	if target_enemy and $HitBox.overlaps_body(target_enemy):
		target_enemy.alive = false

func move() -> void:
	var dir := Input.get_vector(&"Left", &"Right", &"Back", &"Forward")
	if dir:
		const SPEED = 362.5
		velocity = dir * SPEED
		move_and_slide()
		anim_tree[&"parameters/Movement/blend_position"] = dir

func switch_layer(layer_id: int) -> void:
	collision_mask = 1 << layer_id
	$Interactor.collision_mask = collision_mask
	$HitBox.collision_mask = collision_mask


func _input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventKey:
		event = event as InputEventKey
		if event.keycode == KEY_U:
			alive = not alive
		if event.keycode == KEY_SPACE:
			var target_pos := get_global_mouse_position()
			var query := PhysicsPointQueryParameters2D.new()
			query.collide_with_areas = true
			query.collide_with_bodies = false
			query.collision_mask = 1 << 4
			query.position = target_pos
			var bodies = get_world_2d().direct_space_state.intersect_point(query)
			if bodies.is_empty():
				return
			for body in bodies:
				if body.collider.name == "HurtBox":
					target_enemy = body.collider.get_parent()
					if target_enemy == self:
						target_enemy = null
					break
