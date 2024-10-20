class_name Drop extends Item

@export var drop_type : DropType

func _init(new_type_id : String = ""):
	super._init(new_type_id)

func _ready():
	super._ready()
	categories = drop_type.categories
	type_id = drop_type.id
	update()

func _process(delta):
	process_effects()

## UTILS ##


func update():
	if not type_id:
		print("Error: Item type not set")
		return
	# Conversions
	var new_type = Registry.item_types[type_id]
	if new_type == null:
		print("Error: Item type not found [" + type_id+"]")
		return
	if new_type is DropType:
		if not drop_type or new_type.id != drop_type.id:
			drop_type = new_type
	elif new_type is EvoitemType:
		convert_to_evoitem(new_type)
		return
	else:
		print("Error: Invalid item type [" + type_id+"]")
	
	sprite.texture = get_fa_texture()
	background.texture = get_background_texture()

## UTILS ##

func get_fa_texture() -> Texture:
	var path = "res://assets/svgs/regular/" + drop_type.fa_name + ".svg"
	var image = Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(image)
	return texture

func get_background_texture() -> Texture:
	var path = "res://assets/backgrounds/cerchio.png"
	var image = Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(image)
	return texture

## EFFECTS ##

func process_effects():
	for effect in drop_type.effect:
		var items = []
		if effect.radius > 0:
			items = get_siblings_in_categories_in_radius(effect.categories, effect.radius)
		else:
			items = get_siblings_in_categories(effect.categories)
		for item in items:
			item.apply_effect(effect)
