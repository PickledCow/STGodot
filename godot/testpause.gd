extends Node2D

func _ready():
	get_tree().paused = false

export var bg_path: NodePath
export var pause_path: NodePath
onready var pause_sfx = get_node(pause_path)
export var pause_menu_path: NodePath
onready var pause_menu = get_node(pause_menu_path)

func _process(_delta):
	if true:
		update()
	if Input.is_action_just_pressed("debug_disable_bg"):
		get_node(bg_path).hide()



func _draw():
	var p = get_parent()
	for i in range(0,360, 0*72):
		draw_set_transform_matrix(Transform2D(deg2rad(p.a1 + i), Constants.FIELD_SIZE * 0.5))
		draw_texture_rect_region(p.bullet2, Rect2(Vector2(-300,20)- Vector2(64,64), Vector2(128,128)), Rect2(64,64,32,32))
