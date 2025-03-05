extends Item
class_name OutfitItem

enum OutfitType{
	Prisoner,
	Medic,
	Guard
}

@export
var outfit_type: OutfitType
@export
var outfit_visual: SpriteFrames
@export_range(1, 3)
var defense: int
