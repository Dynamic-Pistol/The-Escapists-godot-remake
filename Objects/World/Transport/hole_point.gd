extends Area2D

@export_range(1, 100)
var progress := 1:
	set(new_progress):
		progress = new_progress
		if not is_node_ready():
			await ready
		var frame = roundi(4 - (float(progress) / 100) * 4)
		$UpHole/Visual.frame = frame
		$DownHole/Visual.frame = frame

func can_go_down() -> bool:
	return progress < 100
