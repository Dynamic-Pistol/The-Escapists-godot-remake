extends SubViewportContainer

@onready var sub_viewport: SubViewport = $SubViewport
@onready var mini_map_camera: Camera2D = $SubViewport/MiniMapCamera


#func _ready() -> void:
	#sub_viewport.world_2d = get_world_2d().duplicate()

func _process(_delta: float) -> void:
	mini_map_camera.global_position = PlayerManager.player.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Show MiniMap"):
		visible = not visible
