extends Stats
class_name NpcStats

@export var player_opinion:= 100

func hates_player() -> bool:
	return player_opinion < 30
