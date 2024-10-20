class_name Registry extends Node

static var item_types : Dictionary = {}
static var pack_types : Dictionary = {}
static var crafting_types : Dictionary = {}

static func _static_init():
	# Load JSON files
	load_drop_types("res://jsons/droptypes.json")
	load_evoitem_types("res://jsons/evoitemtypes.json")
	load_pack_types("res://jsons/packitemtypes.json")
	load_crafting_types("res://jsons/craftingtypes.json")

# Drop types
static func load_drop_types(path : String):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_list = JSON.parse_string(json_as_text)
	if json_as_list == null:
		print("Error loading drop_types")
		return
	for j in json_as_list:
		var drop_type : DropType = DropType.new()
		drop_type.id = j["id"]
		drop_type.fa_name = j["fa-name"]
		drop_type.categories = j["categories"]
		drop_type.cost = j["cost"]
		drop_type.effect = []
		for effect in j["effects"]:
			var effect_type : EffectType = EffectType.new()
			effect_type.categories = effect["categories"]
			effect_type.description = effect["description"]
			if effect["type"] == "drop_rate":
				effect_type.type = EffectType.Attribute.DROP_RATE
			elif effect["type"] == "drop_id":
				effect_type.type = EffectType.Attribute.DROP_ID
			elif effect["type"] == "drop_count":
				effect_type.type = EffectType.Attribute.DROP_COUNT
			elif effect["type"] == "id":
				effect_type.type = EffectType.Attribute.ID
			if effect["operation"] == "+=":
				effect_type.operation = EffectType.Operation.ADD
			elif effect["operation"] == "*=":
				effect_type.operation = EffectType.Operation.MULTIPLY
			elif effect["operation"] == "=":
				effect_type.operation = EffectType.Operation.SET
			drop_type.effect.append(effect_type)
		item_types[drop_type.id] = drop_type
		print("Loaded drop type: " + drop_type.id)

# Evoitemtypes
static func load_evoitem_types(path : String):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_list = JSON.parse_string(json_as_text)
	if json_as_list == null:
		print("Error loading evoitem_types")
		return
	for j in json_as_list:
		var evoitem_type : EvoitemType = EvoitemType.new()
		evoitem_type.id = j["id"]
		evoitem_type.fa_name = j["fa-name"]
		evoitem_type.categories = j["categories"]
		evoitem_type.drop_id = j["drop_id"]
		evoitem_type.drop_count = j["drop_count"]
		evoitem_type.drop_rate = j["drop_rate"]
		evoitem_type.cost = j["cost"]
		item_types[evoitem_type.id] = evoitem_type
		print("Loaded evoitem type: " + evoitem_type.id)
	
# Packtypes
static func load_pack_types(path : String):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_list = JSON.parse_string(json_as_text)
	if json_as_list == null:
		print("Error loading pack_types")
		return
	for j in json_as_list:
		var pack_type : PackType = PackType.new()
		pack_type.id = j["id"]
		pack_type.description = j["description"]
		pack_type.cost = j["cost"]
		pack_type.items = []
		for item in j["items"]:
			var pack_item : PackType.PackItem = PackType.PackItem.new()
			pack_item.id = item["id"]
			pack_item.weight = item["weight"]
			pack_type.items.append(pack_item)
		pack_types[pack_type.id] = pack_type
		print("Loaded pack type: " + pack_type.id)

# Craftingtypes
static func load_crafting_types(path : String):
	var json_as_text = FileAccess.get_file_as_string(path)
	var json_as_list = JSON.parse_string(json_as_text)
	if json_as_list == null:
		print("Error loading crafting_types")
		return
	for j in json_as_list:
		var crafting_type : CraftingType = CraftingType.new()
		crafting_type.id1 = j["id1"]
		crafting_type.id2 = j["id2"]
		crafting_type.id_result = j["idResult"]
		crafting_types[crafting_type.id_result] = crafting_type
		print("Loaded crafting type: " + crafting_type.id_result)

# Search crafting type
static func search_crafting_type(id1 : String, id2 : String) -> CraftingType:
	for crafting_type in crafting_types.values():
		if crafting_type.id1 == id1 and crafting_type.id2 == id2:
			return crafting_type
		if crafting_type.id1 == id2 and crafting_type.id2 == id1:
			return crafting_type
	return null
