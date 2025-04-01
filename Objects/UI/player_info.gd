extends Control


func update() -> void:
	$"INT Bar".value = PlayerManager.player.stats.intellect
	$"STR Bar".value = PlayerManager.player.stats.strength
	$"SPD Bar".value = PlayerManager.player.stats.speed
