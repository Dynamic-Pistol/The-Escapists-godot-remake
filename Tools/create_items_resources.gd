extends Node

@export
var item_sheet: Texture2D
var index: Rect2i

@onready
var config := ConfigFile.new()
var id: String

const OFFSET = 64

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config.load("res://Tools/items_eng.txt")
	index.size = Vector2i.ONE * OFFSET
	for i in 278:
		id = str(i)
		if config.has_section_key(id, "Info"):
			var info := config.get_value(id, "Info") as String
			if info.contains("Unlocks"):
				var key = KeyItem.new()
				key.key_type = get_key_type(info)
				var decay = config.get_value(id, "Decay", 0)
				key.decay = decay
				key.fake = (config.get_value(id, "Name") as String).contains("Fake")
				setup_basics(key)
				save_item(key)
				continue
		elif config.has_section_key(id, "FAT") or config.has_section_key(id, "HP"):
			var food = FoodItem.new()
			food.heal_amount = config.get_value(id, "HP")
			food.energy_amount = config.get_value(id, "FAT")
			setup_basics(food)
			save_item(food)
			continue
		elif config.has_section_key(id, "Outfit"):
			var outfit = OutfitItem.new()
			outfit.defense = config.get_value(id, "Outfit")
			setup_basics(outfit)
			outfit.outfit_type = get_outfit_type(outfit.name) 
			save_item(outfit)
			continue
		else:
			var item = Item.new()
			setup_basics(item)
			save_item(item)

func setup_basics(item: Item) -> void:
	item.is_contraband = bool(config.get_value(id, "Illegal", 0))
	item.name = config.get_value(id, "Name")
	if config.has_section_key(id, "Gift"):
		item.opinion_inc = config.get_value(id, "Gift")
	item.base_price = config.get_value(id, "Buy", 0)
	var sprite = AtlasTexture.new()
	sprite.atlas = item_sheet
	sprite.region = index
	if index.end.x == 1088:
		index.position.x = 0
		index.position.y += OFFSET
	else:
		index.position.x += OFFSET
	item.texture = sprite
	

func save_item(item) -> void:
	ResourceSaver.save(item, "res://Resources/Items/" + item.name + ".tres")

func get_key_type(info: String) -> KeyItem.KeyType:
	if info.contains("yellow"):
		return KeyItem.KeyType.CELL
	elif info.contains("purple"):
		return KeyItem.KeyType.ENTERANCE
	elif info.contains("orange"):
		return KeyItem.KeyType.UTILITY
	elif info.contains("green"):
		return KeyItem.KeyType.WORK
	elif info.contains("red"):
		return KeyItem.KeyType.STAFF
	else:
		return KeyItem.KeyType.INVALID

func get_outfit_type(item_name: String) -> OutfitItem.OutfitType:
	if item_name.contains("Guard") or item_name.contains("Henchman") or item_name.contains("Soldier"):
		return OutfitItem.OutfitType.Guard
	elif item_name.contains("Infirmary"):
		return OutfitItem.OutfitType.Medic
	else:
		return OutfitItem.OutfitType.Prisoner
