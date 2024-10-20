class_name Item extends RigidBody2D

var type_id: String = ""
var categories: Array = []
var cost: int = 0

var background: Sprite2D = Sprite2D.new()
var sprite: Sprite2D = Sprite2D.new()

func _init(new_type_id: String = ""):
	type_id = new_type_id

func _ready():
	# Create the background sprite
	background.scale = Vector2(1.882, 1.882)
	add_child(background)
	# Create the item sprite
	sprite.scale = Vector2(0.058, 0.058)
	add_child(sprite)
	# Create the collision shape
	var collision = CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 32
	add_child(collision)
	gravity_scale = 0
	
	connect("input_event", _on_input_event)
	input_pickable = true
	connect("clicked", ($"../..")._on_pickable_clicked)

	update()

func update():
	if not get_parent(): return
	if not type_id:
		print("Error: Item type not set")
		return
	var new_type = Registry.item_types[type_id]
	if new_type == null:
		print("Error: Item type not found [" + type_id + "]")
		return
	if new_type is EvoitemType:
		convert_to_evoitem(new_type)
	elif new_type is DropType:
		convert_to_drop(new_type)
	else:
		print("Error: Invalid item type [" + type_id + "]")

func convert_to_id(new_type_id: String):
	type_id = new_type_id
	update()

func convert_to_drop(new_type: DropType):
	var drop = Drop.new(new_type.id)
	drop.update()
	get_parent().add_child(drop)
	drop.position = position
	print(position)
	queue_free()


func convert_to_evoitem(new_type: EvoitemType):
	var evoitem = Evoitem.new(new_type.id)
	evoitem.update()
	get_parent().add_child(evoitem)
	evoitem.position = position
	queue_free()


## SEARCHING FOR SIBLINGS ##

# Returns the siblings of the item in one of the categories
func get_siblings_in_categories(searched_categories: Array = categories) -> Array[Item]:
	var items: Array[Item] = []
	for item in get_parent().get_children():
		for category in searched_categories:
			if category in item.categories and item != self:
				items.append(item as Item)
	return items

# Returns the siblings of the item in one of the categories in a specific radius
func get_siblings_in_categories_in_radius(searched_categories: Array, radius: int) -> Array[Item]:
	var items: Array[Item] = []
	for item in get_parent().get_children():
		for category in searched_categories:
			if category in item.categories and item != self and item.global_position.distance_to(global_position) <= radius:
				items.append(item as Item)
	return items

# Returns the siblings of the item in the same category
func get_siblings_in_category(searched_category: String) -> Array[Item]:
	return get_siblings_in_categories([searched_category])

# Returns the siblings of the item in the same category in a specific radius
func get_siblings_in_category_in_radius(searched_category: String, radius: int) -> Array[Item]:
	var items: Array[Item] = []
	for item in get_parent().get_children():
		if searched_category in item.categories and item != self and item.global_position.distance_to(global_position) <= radius:
			items.append(item as Item)
	return items

# Returns the siblings of the item with the same type id
func get_siblings_with_id(searched_id: String) -> Array[Item]:
	var items: Array[Item] = []
	for item in get_parent().get_children():
		if item.type_id == searched_id and item != self:
			items.append(item as Item)
	return items

# Returns the siblings of the item with the same type id in a specific radius
func get_siblings_with_id_in_radius(searched_id: String, radius: int) -> Array[Item]:
	var items: Array[Item] = []
	for item in get_parent().get_children():
		if item.type_id == searched_id and item != self and item.global_position.distance_to(global_position) <= radius:
			items.append(item as Item)
	return items

## EFFECTS ##

func apply_effect(effect: EffectType):
	if effect.operation == EffectType.Operation.ADD:
		effect_add(effect)
	elif effect.operation == EffectType.Operation.MULTIPLY:
		effect_multiply(effect)
	elif effect.operation == EffectType.Operation.SET:
		effect_set(effect)
	elif effect.operation == EffectType.Operation.SELL:
		var game : CookieGame = get_parent().get_parent() as CookieGame
		game.try_to_sell(self)

func effect_add(effect: EffectType) -> bool:
	return false

func effect_multiply(effect: EffectType) -> bool:
	return false

func effect_set(effect: EffectType) -> bool:
	if effect.type == EffectType.Attribute.ID:
		type_id = effect.value
		update()
		return true
	else:
		return false

## DRAGGING ##

signal clicked

var held = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()

func pickup():
	if held:
		return
	freeze = true
	held = true
	background.modulate = Color(0.8, 0.8, 0.8, 1)

func drop(impulse=Vector2.ZERO):
	if held:
		freeze = false
		apply_central_impulse(impulse)
		held = false
		background.modulate = Color(1, 1, 1, 1)
