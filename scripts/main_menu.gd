@tool
class_name menu extends Control

var levels = [
	{
		"ui": "res://assets/ui/pong_icon.png",
		"scene": "res://scenes/games/pong/pong.tscn"
	},
	{
		"ui": "res://assets/ui/space_invaders_icon.png",
		"scene": "res://scenes/games/space_invaders/space_invaders.tscn"
	},
	{
		"ui": "res://assets/ui/dk_icon.png",
		"scene": "res://scenes/games/donkey_kong/donkey_kong.tscn"
	},
	{
		"ui": "res://assets/ui/labyrinth_icon.png",
		"scene": "res://scenes/games/labyrinth/labyrinth.tscn"
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	},
	{
		"ui": "res://assets/ui/question_mark_icon.png",
		"scene": ""
	}
]

func _init() -> void:
	var cx = 1920/2
	var cy = 1080/2
	var r = 350
	var angle : float  = 2*PI/levels.size()
	for i in range(levels.size()):
		var x : float  = cx + sin(angle*i)*r
		var y : float = cy - cos(angle*i)*r
		var ui : TextureButton = TextureButton.new()
		ui.texture_normal = load(levels[i]["ui"])
		ui.connect("pressed", go_to_scene.bind(levels[i]["scene"]))
		ui.global_position = Vector2(x-2.5*32,y-2.5*32)
		ui.scale = Vector2(5, 5)
		ui.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		add_child(ui)

func go_to_scene(name):
	if name != "":
		get_tree().change_scene_to_packed(load(name))

func _on_quit_button_pressed() -> void:
	get_tree().quit()
