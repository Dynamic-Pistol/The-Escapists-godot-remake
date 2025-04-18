extends Area2D

@onready var interaction_icon: Sprite2D = $"../InteractionIcon"
@onready var dialogue_box: DialogueBox = $"../Dialogue Box"

var interaction_tween: Tween

func interact(_entity: Entity) -> void:
	if interaction_tween:
		if interaction_tween.is_running():
			return
		interaction_tween.kill()
	interaction_tween = creation_interaction_tween()
	interaction_tween.play()
	dialogue_box.complimented()
	await interaction_tween.finished
	reset_compliment()

func creation_interaction_tween() -> Tween:
	var tween = create_tween().set_parallel()
	tween.tween_property(interaction_icon, "position:y", -56.0, 1.0)
	tween.tween_property(interaction_icon, "modulate:a", 0, 1.0)
	return tween

func reset_compliment() -> void:
	interaction_icon.position.y = -16
	interaction_icon.modulate.a = 1
