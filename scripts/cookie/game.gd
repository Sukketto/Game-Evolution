class_name CookieGame extends Node2D

@export
var money : int = 1000

@onready var items_node : Node = $Items
@onready var camera : Camera2D = $Camera
@onready var header : CanvasLayer = $UI
@onready var packages : HBoxContainer = $UI/Packages
@onready var crafting_area_1 : Area2D = $Camera/CraftingArea1
@onready var crafting_area_2 : Area2D = $Camera/CraftingArea2
@onready var description : Label = $UI/Description
@onready var money_label : Label = $UI/Money
@onready var cost_label : Label = $UI/Cost

func _ready():
	for pack in Registry.pack_types.values():
		var pack_button = Button.new()
		pack_button.mouse_filter = Control.MOUSE_FILTER_PASS
		pack_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		packages.add_child(pack_button)
		pack_button.text = pack.id
		pack_button.connect("pressed", on_pack_pressed.bind(pack))
	money_label.text = "$"+str(money)

func _process(delta):
	if held_object != null:
		$UI/Cost.visible = true
		$UI/Cost.text = str(held_object.cost)
		if held_object is Evoitem:
			$UI/Description.visible = true
			$UI/Description.text ="Allo stato finale "+str(held_object.type_id)+" droppa "+\
			str(held_object.drop_count)+" "+str(held_object.drop_id)+" ogni "+\
			str(held_object.drop_rate)+" secondi"

## PACKS ##

func on_pack_pressed(pack : PackType):
	print("Pressed pack: " + pack.id)
	if money >= pack.cost:
		money -= pack.cost
		money_label.text = "$"+str(money)
		open_pack(pack)
	else:
		print("Not enough money")

func open_pack(pack : PackType):
	for i in range(pack.pack_size):
		var item : Item = Item.new(pack.get_random_item_id())
		var mouse_position = get_global_mouse_position()
		item.global_position = mouse_position + Vector2(randi_range(-50, 50), randi_range(50, 150))
		items_node.add_child(item)
		#TODO: Add animation


## CRAFTING ##

func try_to_craft(item1 : Item, item2 : Item):
	if not item1.type_id or not item2.type_id: return
	var crafting_type : CraftingType = Registry.search_crafting_type(item1.type_id, item2.type_id)
	if crafting_type == null:
		print("Crafting type not found")
		item1.global_position = crafting_area_1.global_position + Vector2(randi_range(-50, 50), randi_range(50, 150))
		item2.global_position = crafting_area_2.global_position + Vector2(randi_range(-50, 50), randi_range(50, 150))
		return
		
	var item = Item.new(crafting_type.id_result)
	items_node.add_child(item)
	var pos_media = crafting_area_1.global_position + crafting_area_2.global_position / 2
	item.global_position = pos_media + Vector2(randi_range(-50, 50), randi_range(50, 150))

	item1.queue_free()
	item2.queue_free()
	#TODO: Add animation
	#TODO: Add sound

## SELLING ##
func try_to_sell(item : Item):
	if item.cost > 0:
		money += item.cost
		money_label.text = "$"+str(money)
		item.queue_free()
		#TODO: Add sound
		#TODO: Add animation

## DRAG AND DROP ##
var held_object = null

func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Vector2(0,0))
			held_object = null
			$UI/Cost.visible = false
			$UI/Description.visible = false


func _on_video_stream_player_finished() -> void:
	$UI.visible = true
	$Livello.show_tutorial()
