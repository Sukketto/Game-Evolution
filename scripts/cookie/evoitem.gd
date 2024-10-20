class_name Evoitem extends Item


@export var evoitem_type : EvoitemType
@export var evolution : Evolution

@export var drop_count : float
@export var drop_rate : float
@export var drop_id : String

@export var progress : float
@export var drop_type : DropType

var progress_bar : ProgressBar = ProgressBar.new()

enum Evolution { 
	SMALL,
	MEDIUM,
	LARGE
}

func _init(new_type_id : String = ""):
	super._init(new_type_id)

func _ready():
	super._ready()
	categories = evoitem_type.categories
	type_id = evoitem_type.id
	cost = evoitem_type.cost
	# Progress bar
	progress_bar.position = Vector2(-21, 34)
	progress_bar.size = Vector2(42,6)
	progress_bar.show_percentage = false
	add_child(progress_bar)

	update()

func _process(delta):
	if not held:
		merge_in_radius()
		update_progress(delta)

func update_progress(delta : float):
	if evolution != Evolution.LARGE: return
	progress += delta
	progress_bar.value = progress
	if progress >= drop_rate:
		progress = 0
		drop_item()

## UTILS ##

func drop_item():
	var bonus = drop_count - floor(drop_count)
	var count : int = floor(drop_count)
	if bonus > randf():
		count += 1
	for i in range(count):
		var item = Drop.new(drop_id)
		get_parent().add_child(item)
		item.position = position + Vector2(randi_range(-32, 32), randi_range(-32, 32))
		item.update()
		# TODO: Add animation

func update():
	if not type_id:
		print("Error: Item type not set")
		return
	# Conversions	
	var new_type = Registry.item_types[type_id]
	if new_type == null:
		print("Error: Item type not found [" + type_id+"]")
		return
	if new_type is EvoitemType:
		if not evoitem_type or new_type.id != evoitem_type.id:
			evoitem_type = new_type
			drop_count = evoitem_type.drop_count
			drop_rate = evoitem_type.drop_rate
			drop_id = evoitem_type.drop_id
			cost = evoitem_type.cost
	elif new_type is DropType:
		if not drop_type or new_type.id != drop_type.id:
			convert_to_drop(new_type)
			return
	else:
		print("Error: Invalid item type [" + type_id+"]")

	sprite.texture = get_fa_texture()
	background.texture = get_background_texture()
	
	progress_bar.visible = evolution == Evolution.LARGE
	progress_bar.max_value = drop_rate

	#TODO: update sprite and background

func evolve():
	if evolution == Evolution.SMALL:
		evolution = Evolution.MEDIUM
	else: 
		evolution = Evolution.LARGE
		progress_bar.visible = true
		progress = 0
	update()

func get_fa_texture() -> Texture:
	var texture_type = get_evoitem_texture_type()
	var path = "res://assets/svgs/" + texture_type[1] + "/" + evoitem_type.fa_name + ".svg"
	var texture : Texture2D = load(path)
	return texture

func get_evoitem_texture_type() -> Array:
	var texture_type = []
	if evolution == Evolution.SMALL:
		texture_type = ["triangolo", "light"]
	elif evolution == Evolution.MEDIUM:
		texture_type = ["quadrato", "regular"]
	elif evolution == Evolution.LARGE:
		texture_type = ["pentagono", "duotone"]
	return texture_type

func get_background_texture() -> Texture:
	var texture_type = get_evoitem_texture_type()
	var path = "res://assets/backgrounds/" + texture_type[0] + ".png"
	var texture : Texture2D = load(path)
	return texture

## SEARCHING ##

# Returns the siblings of the item with the same type id and evolution
func get_mergeables(radius : int) -> Array[Evoitem]:
	var items = get_siblings_with_id_in_radius(type_id, radius)
	var tweens : Array[Evoitem] = []
	for item in items:
		if item is Evoitem and item.evolution == evolution and not item.held:
			tweens.append(item)
	tweens.sort_custom(_sort_by_distance)
	return tweens

## SORTING ##
func _sort_by_distance(a, b):
	return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)

## MERGING ##

# Merges the item with 2/4 other items of the same type id in a specific radius
func merge_in_radius(radius : int = 70):
	var siblings = get_mergeables(radius)

	# Last evolution
	if evolution == Evolution.LARGE:
		return

	# Double merge
	if siblings.size() >= 4:
		siblings[1].queue_free()
		siblings[2].queue_free()
		siblings[3].queue_free()

		self.evolve()
		siblings[0].evolve()
		# TODO: Add animation
	elif siblings.size() >= 2:
		siblings[0].queue_free()
		siblings[1].queue_free()
		
		self.evolve()
		# TODO: Add animation

## EFFECTS ##
func effect_add(effect : EffectType) -> bool:
	if effect.type == EffectType.Attribute.DROP_COUNT:
		drop_count += float(effect.value)
	elif effect.type == EffectType.Attribute.DROP_RATE:
		drop_rate += float(effect.value)
	else:
		return false
	update()
	return true

func effect_multiply(effect : EffectType) -> bool:
	if effect.type == EffectType.Attribute.DROP_COUNT:
		drop_count *= float(effect.value)
	elif effect.type == EffectType.Attribute.DROP_RATE:
		drop_rate *= float(effect.value)
	else:
		return false
	update()
	return true

func effect_set(effect : EffectType) -> bool:
	if not super.effect_set(effect):
		if effect.type == EffectType.Attribute.DROP_COUNT:
			drop_count = float(effect.value)
		elif effect.type == EffectType.Attribute.DROP_RATE:
			drop_rate = float(effect.value)
		elif effect.type == EffectType.Attribute.DROP_ID:
			drop_type = Registry.item_types[effect.value]
		else:
			return false
		update()
	return true
	
